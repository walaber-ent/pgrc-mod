shader_type spatial;
render_mode blend_mix,
	depth_prepass_alpha,
	shadows_disabled,
	specular_disabled,
	unshaded;

uniform bool affine_mapping = true;
uniform float affine_effect_reduction : hint_range(0,10) = 1.0;
uniform sampler2D main_texture : source_color, filter_nearest;
uniform vec4 albedo_color : source_color = vec4(1.0);
uniform vec2 scroll_speed = vec2(0.1, 0);
uniform float uv_scale = 1.0;

global uniform float JITTER;
global uniform vec2 JITTER_RESOLUTION;
global uniform float OVERALL_GAMMA;

varying vec3 world_pos;

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
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	world_pos.y += sin(world_pos.z * 0.12 + TIME) * 1.0;
	
	vec4 snapped_position = snap_to_position(PROJECTION_MATRIX * VIEW_MATRIX * vec4(world_pos, 1.0));
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
	vec2 uv = (world_pos.xz * uv_scale) + scroll_speed * TIME;
	
	vec4 texture_color = texture(main_texture, uv);
	
	float bayer[] = { 0.0, 0.5, 0.75, 0.25 };
	
	
	vec3 albedo = texture_color.rgb * albedo_color.rgb;
	
	ALBEDO = pow(albedo, vec3(OVERALL_GAMMA));
	ALPHA = texture_color.a * albedo_color.a;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}