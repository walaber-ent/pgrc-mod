shader_type spatial;
render_mode blend_mix,
	depth_prepass_alpha,
	shadows_disabled,
	specular_disabled,
	unshaded;

uniform bool affine_mapping = true;
uniform float affine_effect_reduction : hint_range(0,10) = 1.0;
uniform sampler2D main_texture : source_color, filter_nearest;
uniform sampler2D mask_texture : filter_nearest;
uniform sampler2D emission_texture : source_color, filter_nearest;
uniform sampler2D emission_mask : filter_nearest;
uniform vec4 albedo_color : source_color = vec4(1.0);
uniform vec4 livery_color_a : source_color = vec4(1.0);
uniform vec4 livery_color_b : source_color = vec4(1.0);
uniform vec4 emission_val = vec4(0,0,0,0);
uniform vec2 uv_min = vec2(-999.0, -999.0);
uniform vec2 uv_max = vec2(999.0, 999.0);
uniform float cull_dist_min = 20.0;
uniform float cull_dist_max = 30.0;

global uniform float JITTER;
global uniform vec2 JITTER_RESOLUTION;

global uniform vec3 LIGHT_DIR;
global uniform float OVERALL_GAMMA;

varying float l;
varying float cull;

vec4 snap_to_position(vec4 base_position)
{
	vec4 snapped_position = base_position;
	snapped_position.xyz = base_position.xyz / base_position.w;
	
	vec2 snap_resulotion = floor(vec2(JITTER_RESOLUTION) * (1.0 - JITTER));
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
	l = clamp(dot(-normalize(LIGHT_DIR), normalize(world_normal)), 0.0, 1.0);
	
	float view_dist = abs(MODELVIEW_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).z;
	cull = smoothstep(cull_dist_max, cull_dist_min, view_dist);
}

void fragment()
{
	vec2 uv = clamp(UV, uv_min, uv_max);
	
	vec4 texture_color = texture(main_texture, uv);
	vec4 mask_color = texture(mask_texture, uv);
	vec4 emission_color = texture(emission_texture, uv);
	vec4 emission_mask_color = texture(emission_mask, uv);
	float emit_v = length(emission_val * emission_mask_color);
	
	ivec2 screen_pixel = ivec2(SCREEN_UV * VIEWPORT_SIZE);
	
	//float bayer[] = { 0.0, 0.5, 0.75, 0.25 };
	
	float original_a = texture_color.a * cull;
	//float bayer_val = bayer[ ((screen_pixel.y % 2) * 2) + (screen_pixel.x % 2) ];
	
	float alpha = step(0.5, original_a - 0.01);
	
	vec3 albedo = (texture_color).rgb;
	vec3 albedo_w_a = mix(albedo, albedo * livery_color_a.rgb, smoothstep(0.1, 0.9, mask_color.r));
	albedo = mix(albedo_w_a, albedo * livery_color_b.rgb, smoothstep(0.1, 0.9, mask_color.g));
	
	float albedo_bright = dot(albedo.rgb, vec3(0.3, 0.6, 0.1));
	float emission_bright = dot(emission_color.rgb, vec3(0.3, 0.6, 0.1));
	float emit = step(albedo_bright, emission_bright) * emit_v;
	
	albedo = mix(albedo, emission_color.rgb, emit);
	
	albedo *= albedo_color.rgb;
	
	float final_l = mix(0.3, 1.0, round(l * 16.0) / 16.0);
	ALBEDO = pow(albedo * mix(final_l, 1.0, emit), vec3(OVERALL_GAMMA));
	//ALBEDO = round(ALBEDO * 64.0) / 64.0;
	ALPHA = alpha;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}