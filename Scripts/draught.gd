extends MeshInstance3D

var pos = []
var is_black: bool
signal draught_is_clicked(y, x, is_black, draught)


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		draught_is_clicked.emit(pos.back(), pos.front(), is_black, self)

func getX():
	return pos.front()
	
func getY():
	return pos.back()


func _on_area_3d_mouse_entered() -> void:
	pass
