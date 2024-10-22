shader_type spatial;
render_mode blend_mix,
	cull_disabled,
	depth_prepass_alpha,
	shadows_disabled,
	specular_disabled,
	unshaded;

uniform bool affine_mapping = true;
uniform float affine_effect_reduction : hint_range(0,10) = 1.0;
uniform sampler2D main_texture : source_color, filter_nearest;
uniform vec4 albedo_color : source_color = vec4(1.0);
uniform float texture_color_factor : hint_range(0,1) = 1.0;
uniform bool billboard = false;
uniform bool full_billboard = false;
uniform int albedo_steps = 64;
uniform float billboard_roll = 0.0;
uniform vec3 billboard_scale = vec3(1.0, 1.0, 1.0);

global uniform float JITTER;
global uniform vec2 JITTER_RESOLUTION;
global uniform float OVERALL_GAMMA;

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
	if (billboard)
	{
		// hacky version that tries to keep the model's Y but use camera's X and Z
		mat4 mat_world;
		
		if (full_billboard)
		{
			mat_world = mat4(normalize(INV_VIEW_MATRIX[0]), normalize(INV_VIEW_MATRIX[1]) ,normalize(INV_VIEW_MATRIX[2]), MODEL_MATRIX[3]);
		}
		else
		{
			mat_world = mat4(normalize(INV_VIEW_MATRIX[0]), normalize(MODEL_MATRIX[1]) ,normalize(INV_VIEW_MATRIX[2]), MODEL_MATRIX[3]);
		}
			
		//rotate by roll
		mat_world = mat_world * mat4(vec4(cos(billboard_roll), -sin(billboard_roll), 0.0, 0.0), vec4(sin(billboard_roll), cos(billboard_roll), 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));

		//set modelview
		MODELVIEW_MATRIX = VIEW_MATRIX * mat_world;
			
		// keep scale
		MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(MODEL_MATRIX[0].xyz) * billboard_scale.x, 0.0, 0.0, 0.0),vec4(0.0, length(MODEL_MATRIX[1].xyz) * billboard_scale.y, 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz) * billboard_scale.z, 0.0), vec4(0.0, 0.0, 0.0, 1.0));

		//set modelview normal
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
	
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
}

void fragment()
{
	vec4 vert_base = COLOR;
	vec4 texture_color = texture(main_texture, UV);
	
	ivec2 screen_pixel = ivec2(SCREEN_UV * VIEWPORT_SIZE);
	
	float bayer[] = { 	00.0/16.0, 12.0/16.0, 03.0/16.0, 15.0/16.0, 
						08.0/16.0, 04.0/16.0, 11.0/16.0, 07.0/16.0, 
						02.0/16.0, 14.0/16.0, 01.0/16.0, 13.0/16.0,
						10.0/16.0, 06.0/16.0, 09.0/16.0, 05.0/16.0 };
	
	float original_a = vert_base.a * texture_color.a * albedo_color.a;
	float bayer_val = bayer[ ((screen_pixel.y % 4) * 4) + (screen_pixel.x % 4) ];
	
	float alpha = step(bayer_val, original_a - 0.01);
	
	vec3 albedo = (vert_base * mix(vec4(1.0), texture_color, texture_color_factor) * albedo_color).rgb;

	ALBEDO = albedo.rgb;
	ALBEDO = round(ALBEDO * float(albedo_steps)) / float(albedo_steps);
	ALBEDO = pow(ALBEDO, vec3(OVERALL_GAMMA));
	ALPHA = alpha;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}