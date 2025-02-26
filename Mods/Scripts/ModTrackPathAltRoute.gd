@tool

extends MeshInstance3D
class_name ModTrackPathAltRoute

@export var material : Material

@export var bezier_handle_length : float = 2.0:
	set(val):
		bezier_handle_length = val
		if Engine.is_editor_hint():
			refresh_mesh()
		
@export var track_width : float = 6.0:
	set(val):
		track_width = val
		if Engine.is_editor_hint():
			refresh_mesh()
		
@export var vert_spacing : float = 2.0:
	set(val):
		vert_spacing = val
		if Engine.is_editor_hint():
			refresh_mesh()

var _mesh : ImmediateMesh
var _curve : Curve3D

func _ready() -> void:
	if Engine.is_editor_hint():
		refresh_mesh()
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		if Engine.is_editor_hint():
			refresh_mesh()

func get_track_curve() -> Curve3D:
	return _curve


func refresh_mesh(start_uv:float = 0.0, end_uv:float = 1.0, force_new:bool = false) -> void:
	if get_child_count() == 0:
		return
	
	var uv_range : float = end_uv - start_uv
	
	if _mesh == null or force_new:
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
		var direction : Vector3 = (_curve.sample_baked(d + final_spacing) - pt).normalized()
		var right : Vector3 = direction.cross(Vector3.UP) #pt_t.basis * Vector3.RIGHT
		right.y = 0.0
		right = right.normalized()
		
		var uv_x : float = start_uv + ((d / length) * uv_range)
		
		_mesh.surface_set_uv(Vector2(uv_x, 0.0))
		_mesh.surface_add_vertex(pt + (right * track_width * 0.5))
		
		_mesh.surface_set_uv(Vector2(uv_x, 1.0))
		_mesh.surface_add_vertex(pt - (right * track_width * 0.5))
		
		d = minf(d + final_spacing, length)
		
	_mesh.surface_end()
