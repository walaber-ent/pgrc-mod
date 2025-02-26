@tool

extends Node3D
class_name ModTrackPathPoint

func _ready() -> void:
	set_notify_transform(true)

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:		
		var parent_path : ModTrackPath = get_parent() as ModTrackPath
		if parent_path:
			if Engine.is_editor_hint():
				parent_path.refresh_mesh()
			
		var parent_alt_route : ModTrackPathAltRoute = get_parent() as ModTrackPathAltRoute
		if parent_alt_route:
			if Engine.is_editor_hint():
				parent_alt_route.refresh_mesh()
	
