@tool
extends Node3D
class_name ModBarrierRailing

@onready var railing_barrier_yellow: Node3D = %"railing-barrier-yellow"
@onready var railing_barrier_banner_1: Node3D = %"railing-barrier-banner-1"
@onready var railing_barrier_banner_2: Node3D = %"railing-barrier-banner-2"
@onready var railing_barrier_banner_3: Node3D = %"railing-barrier-banner-3"
@onready var railing_barrier_banner_4: Node3D = %"railing-barrier-banner-4"


enum RailingType { YELLOW, BANNER_1, BANNER_2, BANNER_3, BANNER_4 }

@export var railing_type : RailingType = RailingType.BANNER_1:
	set(val):
		railing_type = val
		refresh_mesh()
		
func _ready() -> void:
	refresh_mesh()
	
	
func refresh_mesh() -> void:
	if not is_inside_tree():
		return
		
	var meshes : Array[Node3D] = [
		railing_barrier_yellow,
		railing_barrier_banner_1,
		railing_barrier_banner_2,
		railing_barrier_banner_3,
		railing_barrier_banner_4,
	]
	
	var types : Array[RailingType] = [
		RailingType.YELLOW,
		RailingType.BANNER_1,
		RailingType.BANNER_2,
		RailingType.BANNER_3,
		RailingType.BANNER_4,
	]
	
	for i in range(meshes.size()):
		meshes[i].visible = railing_type == types[i]
