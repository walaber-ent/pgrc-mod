@tool

extends MeshInstance3D
class_name ModTrackPath

@export var material : Material

@export var bezier_handle_length : float = 2.0:
	set(val):
		bezier_handle_length = val
		refresh_mesh()
		
@export var track_width : float = 6.0:
	set(val):
		track_width = val
		refresh_mesh()
		
@export var vert_spacing : float = 2.0:
	set(val):
		vert_spacing = val
		refresh_mesh()

var _mesh : ImmediateMesh
var _curve : Curve3D

func _ready() -> void:
	refresh_mesh()
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		refresh_mesh()

func get_track_curve() -> Curve3D:
	return _curve


func refresh_mesh() -> void:
	if _mesh == null:
		_mesh = ImmediateMesh.new()
		mesh = _mesh
		
	if _curve == null:
		_curve = Curve3D.new()
	else:
		_curve.clear_points()
		
	var hl : float = maxf(bezier_handle_length, 0.0)
	
	for i in range(get_child_count()):
		var t : Node3D = get_child(i) as Node3D
		if t:
			var prev_dir : Vector3 = Vector3.ZERO
			if i > 0:
				prev_dir = ((get_child(i-1) as Node3D).position - t.position).normalized()
				
			var next_dir : Vector3 = Vector3.ZERO
			if i < get_child_count()-1:
				next_dir = ((get_child(i+1) as Node3D).position - t.position).normalized()
				
			_curve.add_point(t.position,t.basis * Vector3(0.0, 0.0, -hl), t.basis * Vector3(0.0, 0.0, hl))
	
	_curve.bake_interval = 0.05
	
	var length : float = _curve.get_baked_length()
	var pt_count : int = ceili(length / maxf(vert_spacing, 0.25))
	
	var final_spacing : float = length / pt_count
	
	_mesh.clear_surfaces()
	_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP, material)
	
	var d : float = 0.0
	for i in range(pt_count):
		var pt_t : Transform3D = _curve.sample_baked_with_rotation(d, false, false)
		var pt : Vector3 = pt_t.origin
		var right : Vector3 = pt_t.basis * Vector3.RIGHT
		right.y = 0.0
		right = right.normalized()
		
		var uv_x : float = d / length
		
		# last point special logic
		if i == pt_count-1:
			pt_t = _curve.sample_baked_with_rotation(0.0, false, false)
			pt = pt_t.origin
			right = pt_t.basis * Vector3.RIGHT
			right.y = 0.0
			right = right.normalized()
			uv_x = 1.0
			
		_mesh.surface_set_uv(Vector2(uv_x, 0.0))
		_mesh.surface_add_vertex(pt + (right * track_width * 0.5))
		
		_mesh.surface_set_uv(Vector2(uv_x, 1.0))
		_mesh.surface_add_vertex(pt - (right * track_width * 0.5))
		
		d = minf(d + final_spacing, length)
		
	_mesh.surface_end()
		
		
		
	
	
	
	
	
