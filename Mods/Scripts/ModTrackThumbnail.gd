extends Node3D
class_name ModTrackThumbnail

@onready var bounds: MeshInstance3D = %"Bounds (Will Be Hidden)"

func _ready() -> void:
	bounds.hide()
