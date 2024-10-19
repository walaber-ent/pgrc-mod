@tool

extends Node3D
class_name ModTrackPathPoint

func _ready() -> void:
	set_notify_transform(true)

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:		
		var parent : ModTrackPath = get_parent() as ModTrackPath
		if parent:
			parent.refresh_mesh()
	
