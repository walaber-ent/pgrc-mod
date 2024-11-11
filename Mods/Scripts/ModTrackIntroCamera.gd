@tool

extends Node3D
class_name ModTrackIntroCamera

@export var camera_anim_curve : Curve
@export var camera_look_curve : Curve

@onready var camera_path: Path3D = %CameraPath
@onready var look_path: Path3D = %LookPath

@onready var cam: Camera3D = %cam
@onready var look: Marker3D = %look


@export_range(0.0, 1.0) var preview_interp : float:
	set(val):
		preview_interp = val
		refresh_preview()


func refresh_preview() -> void:
	interp(preview_interp)

	
func interp(i:float) -> void:
	var cam_interp : float = i
	var look_interp : float = i
	
	if camera_anim_curve != null:
		cam_interp = camera_anim_curve.sample(i)
		
	if camera_look_curve != null:
		look_interp = camera_look_curve.sample(i)
		
	var cam_length : float = camera_path.curve.get_baked_length()
	cam.global_position = camera_path.to_global(camera_path.curve.sample_baked(cam_interp * cam_length))

	var look_length : float = look_path.curve.get_baked_length()
	look.global_position = look_path.to_global(look_path.curve.sample_baked(look_interp * look_length))
	
	cam.global_basis = Basis.looking_at(look.global_position - cam.global_position, Vector3.UP)
	
	
