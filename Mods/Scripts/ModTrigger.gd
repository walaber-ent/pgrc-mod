@tool

extends MeshInstance3D
class_name ModTrigger

@export var size : Vector3 = Vector3(2,2,2):
	set(val):
		size = val
		_refresh_size()

var _box_mesh : BoxMesh = null

func _ready() -> void:
	_box_mesh = BoxMesh.new()
	mesh = _box_mesh
	
	_refresh_size()

func _refresh_size():
	# there might be a better wat to do this, but _shrug_
	if not is_node_ready():
		return
	
	_box_mesh.size = size

