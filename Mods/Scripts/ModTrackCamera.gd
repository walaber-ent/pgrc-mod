@tool

extends Node3D
class_name ModTrackCamera

@export var fov : float = 75.0:
	set(val):
		fov = val
		_did_change()
		
@export var base_dist : float = 10.0:
	set(val):
		base_dist = val
		_did_change()
		
@export var dist_zoom_factor : float = 1.0:
	set(val):
		dist_zoom_factor = val
		_did_change()
		
@export var fov_range : Vector2 = Vector2(5.0, 90.0):
	set(val):
		fov_range = val
		_did_change()

@export var pan_with_target : bool = true:
	set(val):
		pan_with_target = val
		_did_change()
		
@export var target_offset : Vector3 = Vector3(0,0,0):
	set(val):
		target_offset = val
		_did_change()

func _ready() -> void:
	set_notify_transform(true)
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		_did_change()

func _did_change() -> void:
	# look for the previewer!
	var track_cameras : Node3D = get_parent_node_3d()
	if not track_cameras:
		return
	
	print("a")
	
	var track : ModTrack = track_cameras.get_parent() as ModTrack
	if not track:
		return
	
	print("b")
	
	var previewer : ModTrackCameraPreviewer = track.get_node("TrackCameraPreviewer") as ModTrackCameraPreviewer
	if previewer:
		print("c")
		previewer.refresh_now()
	

@export var starting_track_interp : float = 0.0
