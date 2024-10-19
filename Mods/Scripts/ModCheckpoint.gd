@tool

extends Node3D
class_name ModCheckpoint

@onready var buoy_l: Node3D = %buoy_L
@onready var buoy_r: Node3D = %buoy_R
@onready var trigger: MeshInstance3D = %trigger
@onready var reset_pos: Node3D = %reset_pos



@export var size : Vector2 = Vector2(8,5):
	set(val):
		size = val
		_refresh_size()

func _ready() -> void:
	var box_mesh : Mesh = trigger.mesh.duplicate()
	trigger.mesh = box_mesh
	
	_refresh_size()

func _refresh_size():
	# there might be a better wat to do this, but _shrug_
	if not is_node_ready():
		return
		
	if buoy_l:
		buoy_l.position = Vector3(0.0, 0.0, 0.0)
		
	if buoy_r:
		buoy_r.position = Vector3(size.x, 0.0, 0.0)
	
	var half_size = size * 0.5
	trigger.basis = Basis()
	trigger.position = Vector3(half_size.x, half_size.y, 0.0)
	(trigger.mesh as BoxMesh).size = Vector3(size.x, size.y, 0.2)
	
	reset_pos.position = Vector3(half_size.x, 0.6, 1.0)
	reset_pos.basis = Basis()

