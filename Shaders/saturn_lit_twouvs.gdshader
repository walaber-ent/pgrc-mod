shader_type spatial;
render_mode blend_mix,
	depth_prepass_alpha,
	shadows_disabled,
	specular_disabled,
	unshaded;

uniform bool affine_mapping = true;
uniform float affine_effect_reduction : hint_range(0,10) = 1.0;
uniform sampler2D main_texture : source_color, filter_nearest;
uniform sampler2D second_texture : source_color, filter_nearest, repeat_disable;
uniform vec4 albedo_color : source_color = vec4(1.0);
uniform float alpha_scissor : hint_range(0, 1) = 0.5;
uniform float jitter: hint_range(0, 1) = 0.4;
uniform ivec2 resolution = ivec2(320, 240);
uniform vec2 uv_min = vec2(-999.0, -999.0);
uniform vec2 uv_max = vec2(999.0, 999.0);
uniform float vert_color_gamma = 1.0;
uniform float vert_color_mult = 1.0;
uniform float vert_color_gain = 0.0;
uniform float vert_color_factor : hint_range(0,1) = 1.0;
uniform int vert_color_range = 64;
uniform bool culling_on = true;
uniform float cull_bias = 0.0;
uniform float cull_near_far : hint_range(0,1) = 0.0;
uniform float cull_pop_factor : hint_range(0,1) = 0.0;
uniform vec2 dir_light_contrib_range = vec2(0.3, 1.0);
uniform bool grid_culling = false;
uniform float grid_size = 8.0;
uniform bool fog_on = false;
uniform vec4 fog_color : source_color = vec4(1.0);
uniform vec2 fog_dist_range = vec2(100.0, 200.0);
uniform vec2 fog_intensity_range = vec2(0.0, 0.4);
uniform int fog_value_range = 64;

global uniform vec3 LIGHT_DIR;

global uniform vec2 CULL_DIST_NEAR;
global uniform vec2 CULL_DIST_FAR;
global uniform float CULL_DIST_BIAS;

global uniform float OVERALL_GAMMA;

varying float l;
varying float cull;
varying float fog;

vec4 snap_to_position(vec4 base_position)
{
	vec4 snapped_position = base_position;
	snapped_position.xyz = base_position.xyz / base_position.w;
	
	vec2 snap_resulotion = floor(vec2(resolution) * (1.0 - jitter));
	snapped_position.x = floor(snap_resulotion.x * snapped_position.x) / snap_resulotion.x;
	snapped_position.y = floor(snap_resulotion.y * snapped_position.y) / snap_resulotion.y;
	
	snapped_position.xyz *= base_position.w;
	return snapped_position;
}

void vertex()
{
	vec4 snapped_position = snap_to_position(PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	if (affine_mapping)
	{
		POSITION = snapped_position;
		POSITION /= max(abs(POSITION.w), affine_effect_reduction);
	}
	else
	{
		POSITION = snapped_position;
	}
	
	vec3 world_normal = (MODEL_MATRIX * vec4(NORMAL, 0)).xyz;
	l = mix(dir_light_contrib_range.x,
			dir_light_contrib_range.y, 
			clamp(dot(-normalize(LIGHT_DIR), normalize(world_normal)), 0.0, 1.0));
	vec3 cull_world_pos = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	if (grid_culling)
	{
		cull_world_pos = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
		cull_world_pos = floor(cull_world_pos / grid_size) * grid_size;
	}
	
	float view_dist = abs(VIEW_MATRIX * vec4(cull_world_pos, 1.0)).z;
	
	if (culling_on)
	{
		vec2 cull_range = mix(CULL_DIST_NEAR, CULL_DIST_FAR, cull_near_far);
		float cull_mid = mix(cull_range.x, cull_range.y, 0.5);
		cull_range.x = mix(cull_range.x, cull_mid - 0.0001, cull_pop_factor);
		cull_range.y = mix(cull_range.y, cull_mid + 0.0001, cull_pop_factor);
		cull_range.x += min(CULL_DIST_BIAS + cull_bias, 999.0);
		cull_range.y += min(CULL_DIST_BIAS + cull_bias, 999.0);
		cull = smoothstep(cull_range.y, cull_range.x, view_dist);
	}
	else
	{
		cull = 1.0;
	}
	
	fog = 0.0;
	
	if (fog_on)
	{
		float fog_interp = smoothstep(fog_dist_range.x, fog_dist_range.y, view_dist);
		fog = mix(fog_intensity_range.x, fog_intensity_range.y, fog_interp);
		fog = round(fog * float(fog_value_range)) / float(fog_value_range);
	}
	
	COLOR = round(COLOR * float(vert_color_range)) / float(vert_color_range);
	
}

void fragment()
{
	vec2 uv = clamp(UV, uv_min, uv_max);
	vec2 uv2 = clamp(UV2, uv_min, uv_max);
	
	vec4 vert_color = COLOR;
	vec4 vert_base = vec4((pow(vert_color.rgb, vec3(vert_color_gamma)) * vert_color_mult) + vec3(vert_color_gain), COLOR.a);
	vec4 texture_color = texture(main_texture, uv);
	vec4 second_texture_color = texture(second_texture, uv2);
	
	ivec2 screen_pixel = ivec2(SCREEN_UV * VIEWPORT_SIZE);
	
	float bayer[] = { 0.0, 0.5, 0.75, 0.25 };
	
	float original_a = vert_base.a * texture_color.a * albedo_color.a * cull;
	float bayer_val = bayer[ ((screen_pixel.y % 2) * 2) + (screen_pixel.x % 2) ];
	
	float alpha = step(bayer_val, original_a - 0.01);
	
	vec4 albedo = texture_color * albedo_color * second_texture_color;
	vec4 lit_albedo = vert_base * albedo;
	lit_albedo = mix(albedo, lit_albedo, vert_color_factor);
	
	if (fog_on)
	{
		lit_albedo = mix(lit_albedo, fog_color, fog);
	}
	
	ALBEDO = pow(lit_albedo.rgb * l, vec3(OVERALL_GAMMA));
	ALPHA = alpha;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor;
}