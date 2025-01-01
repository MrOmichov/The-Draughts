extends Node3D

var white_draught_sc = preload('res://Scenes/white_draught.tscn')


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var white_cells = [
		$A1, $C1, $E1, $G1,
		$B2, $D2, $F2, $H2,
		$A3, $C3, $E3, $G3
	]
	
	for cell in white_cells:
		var white_draught = white_draught_sc.instantiate()
		white_draught.position.x = cell.position.x
		white_draught.position.z = cell.position.z
		white_draught.position.y = 0
		add_child(white_draught)
	#for i in range(1, 3):
		#var draught = get_node("White/Draught_white_" + str(i))
		#draught.draught_is_clicked.connect(_on_draught_input_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_draught_input_event(pos) -> void:
	print("Clicked")


func _on_draught_mouse_entered() -> void:
	pass
