@tool

extends Node3D
class_name ModTrackCameraPreviewer

@onready var car_proxy: Node3D = %car_proxy
@onready var cam_preview: MeshInstance3D = %cam_preview

var _preview_mesh : ImmediateMesh = null

@export_range(0.0, 1.0) var preview_car_interp : float:
	set(val):
		preview_car_interp = val
		refresh_now()
		

func _ready() -> void:
	cam_preview.hide()
	
func refresh_now() -> void:
	if not is_inside_tree():
		return
		
	print("refresh now")
	var track_path : ModTrackPath = get_parent().get_node("TrackPath") as ModTrackPath
	
	if (track_path == null):
		return
		
	var track_cams : Node3D = get_parent().get_node("TrackCameras") as Node3D
	var active_cam : ModTrackCamera = null
	
	if (track_cams == null):
		return
	
	var prev_interp : float = 0.0
	for cam : ModTrackCamera in track_cams.get_children():
		if cam.starting_track_interp > preview_car_interp:
			break
			
		active_cam = cam
	
	
	var curve : Curve3D = track_path.get_track_curve()
	var length : float = curve.get_baked_length()
	var car_t : Transform3D = curve.sample_baked_with_rotation(preview_car_interp * length, false, false)
		
	car_proxy.global_transform = track_path.transform * car_t * Transform3D(Basis(Vector3.UP, PI), Vector3.ZERO)

	if active_cam != null:
		_refresh_cam_preview(active_cam)
	else:
		cam_preview.hide()
	


func _refresh_cam_preview(cam:ModTrackCamera) -> void:
	var cam_look : Vector3 = -cam.global_basis.z
	var cam_fov : float = cam.fov
	var cam_dist : float = clampf(cam.base_dist, 5.0, 30.0)
	
	if (cam.pan_with_target):
		var dist = cam.global_position.distance_to(car_proxy.global_position)
		var zoom = (cam.base_dist / dist) / cam.dist_zoom_factor
	
		var final_fov = clampf(cam.fov * zoom, cam.fov_range.x, cam.fov_range.y)
	
		cam_fov = final_fov
		
		var target : Vector3 = car_proxy.global_position + cam.target_offset
		
		cam_look = (target - cam.global_position)
		cam_dist = cam_look.length()
		cam_look = cam_look.normalized()
	
	# update the preview mesh now
	if _preview_mesh == null:
		_preview_mesh = ImmediateMesh.new()
		cam_preview.mesh = _preview_mesh
		
	_preview_mesh.clear_surfaces()
	
	_preview_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	print(cam_fov)
	var tan_a : float = tan(deg_to_rad(cam_fov) * 0.5)
	var height : float =  (cam_dist * tan_a)
	var width : float = height * 4.0 / 3.0
	
	var basis : Basis = Basis.looking_at(cam_look * cam_dist, Vector3.UP)
	
	var cam_pos : Vector3 = cam.global_position
	var focus_center = cam_pos + (cam_look * cam_dist)
	
	var corners : Array[Vector3] = []
	for y in [-1,1]:
		for x in [-1,1]:
			corners.append(focus_center + (basis * Vector3(x * width, y * height, 0)))

	print(corners)
	for v in corners:			
		_preview_mesh.surface_add_vertex(cam_preview.to_local(cam_pos))
		_preview_mesh.surface_add_vertex(cam_preview.to_local(v))
		
	_preview_mesh.surface_add_vertex(cam_preview.to_local(corners[0]))
	_preview_mesh.surface_add_vertex(cam_preview.to_local(corners[1]))
	
	_preview_mesh.surface_add_vertex(cam_preview.to_local(corners[2]))
	_preview_mesh.surface_add_vertex(cam_preview.to_local(corners[3]))
	
	_preview_mesh.surface_add_vertex(cam_preview.to_local(corners[0]))
	_preview_mesh.surface_add_vertex(cam_preview.to_local(corners[2]))
	
	_preview_mesh.surface_add_vertex(cam_preview.to_local(corners[1]))
	_preview_mesh.surface_add_vertex(cam_preview.to_local(corners[3]))

	_preview_mesh.surface_end()
	cam_preview.show()
