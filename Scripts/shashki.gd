extends Node3D

var white_draught_res = preload('res://Scenes/white_draught.tscn')
var black_draught_res = preload('res://Scenes/black_draught.tscn')

var the_chosen_one
var whites = []
var blacks = []

var board = [
	[0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0],
]

func draughts_info(draughts: Array):
	for draught in draughts:
		print(draught.name, ' ', draught.pos.front(), ', ', draught.pos.back())

func cells_info(cells: Array):
	for cell in cells:
		print(cell.name, '(Y: ', cell.pos[0], '; X:', cell.pos[1], ')')

func draughts_init(is_black: bool):
	var name = ''
	var cells = []
	var draught_res
	if not is_black:
		cells = [
			$A1, $C1, $E1, $G1,
			$B2, $D2, $F2, $H2,
			$A3, $C3, $E3, $G3
		]
		draught_res = white_draught_res
		name = 'white_draught'
	else:
		cells = [
			$B6, $D6, $F6, $H6,
			$A7, $C7, $E7, $G7,
			$B8, $D8, $F8, $H8,
		]
		draught_res = black_draught_res
		name = 'black_draught'
		
	
	var count = 0
	var is_odd_line = int(is_black)
	for cell in cells:
		var draught = draught_res.instantiate()
		draught.position.x = cell.position.x
		draught.position.z = cell.position.z
		draught.position.y = 0.9
		draught.is_black = is_black
		draught.pos.append_array([count % 4 * 2 + is_odd_line, count / 4 + 5 * int(is_black)])
		
		draught.name = name + str(count + 1)
		add_child(draught)
		if is_black:
			blacks.append(draught)
		else:
			whites.append(draught)
		count += 1
		if count != 0 and count % 4 == 0:
			is_odd_line = int(not is_odd_line)
		draught.draught_is_clicked.connect(_on_draught_input_event)

func board_init():
	var cells = [
		$A1, $C1, $E1, $G1,
		$B2, $D2, $F2, $H2,
		$A3, $C3, $E3, $G3,
		$B6, $D6, $F6, $H6,
		$A7, $C7, $E7, $G7,
		$B8, $D8, $F8, $H8,
	]
	var dict = {"A": 0, "B": 1, "C": 2, "D": 3, "E": 4, "F": 5, "G": 6, "H": 7,}
	for cell in cells:
		cell.pos.append(int(cell.name.right(1)) - 1)
		cell.pos.append(dict[cell.name.left(1)])
	for w in whites:
		board[w.getY()][w.getX()] = 1
	for b in blacks:
		board[b.getY()][b.getX()] = 2
	#cells_info(cells)

func moves(y, x, is_black) -> Array:
	var d = -1 if is_black else 1
	var moves = []
	if x < 7 and board[y + d][x + 1] == 0:
		moves.append([y + d, x + 1])
	if x > 0 and board[y + d][x - 1] == 0:
		moves.append([y + d, x - 1])
	if moves.is_empty():
		return[[-1, -1]]
	return moves

func _ready() -> void:
	draughts_init(false)
	draughts_init(true)
	board_init()


func _process(delta: float) -> void:
	pass


func _on_draught_input_event(y, x, is_black, draught) -> void:
	print('Coords of the clicked draught are (Y: ', y, ' X: ', x, ')')
	var move_possibility
	move_possibility = false if moves(y, x, is_black)[0][0] == -1 else true
	print('This draught move possibility is ', move_possibility)
	if move_possibility: 
		set_moves(moves(y, x, is_black))
		the_chosen_one = draught

func set_moves(moves):
	var dict = {0: "A", 1: "B", 2: "C", 3: "D", 4: "E", 5: "F", 6: "G", 7: "H",}
	for move in moves:
		var cell = get_node(dict[move[1]] + str(move[0] + 1))
		
		var material = cell.get_active_material(0).duplicate()
		material.set_feature(BaseMaterial3D.FEATURE_EMISSION, true)
		cell.set_surface_override_material(0, material)

func _on_draught_mouse_entered() -> void:
	pass
