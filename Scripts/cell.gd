extends MeshInstance3D

var pos = [] # X, Y
signal cell_is_clicked(y, x, position_x, position_z)

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_area_3d_mouse_entered() -> void:
	#var material = get_active_material(0).duplicate()
	#material.set_feature(BaseMaterial3D.FEATURE_EMISSION, true)
	#set_surface_override_material(0, material)
	pass

func _on_area_3d_mouse_exited() -> void:
	#var material = get_active_material(0).duplicate()
	#material.set_feature(BaseMaterial3D.FEATURE_EMISSION, false)
	#set_surface_override_material(0, material)
	pass

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		var material = get_active_material(0)
		if material.get_feature(BaseMaterial3D.FEATURE_EMISSION):
			cell_is_clicked.emit(pos.back(), pos.front(), position.x, position.z)

func getX():
	return pos.front()

func getY():
	return pos.back()
