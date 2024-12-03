extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(1, 3):
		var draught = get_node("White/Draught_white_" + str(i))
		draught.draught_is_clicked.connect(_on_draught_input_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_draught_input_event(pos) -> void:
	print("Clicked")


func _on_draught_mouse_entered() -> void:
	pass
