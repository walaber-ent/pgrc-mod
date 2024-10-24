@tool
extends Node3D
class_name ModBarrierArrowBlock

@onready var arrow_barrier_one_way: Node3D = %"arrow-barrier-one-way"
@onready var arrow_barrier_two_way: Node3D = %"arrow-barrier-two-way"
@onready var arrow_barrier_two_way_reversed: Node3D = %"arrow-barrier-two-way-reversed"

enum ArrowType { ONE_WAY, TWO_WAY, TWO_WAY_REVERSED }

@export var arrow_type : ArrowType = ArrowType.ONE_WAY:
	set(val):
		arrow_type = val
		refresh_mesh()
		
func _ready() -> void:
	refresh_mesh()
	
	
func refresh_mesh():
	if not is_inside_tree():
		return
		
	arrow_barrier_one_way.visible = arrow_type == ArrowType.ONE_WAY
	arrow_barrier_two_way.visible = arrow_type == ArrowType.TWO_WAY
	arrow_barrier_two_way_reversed.visible = arrow_type == ArrowType.TWO_WAY_REVERSED
