extends Node3D

var white_draught_res = preload('res://Scenes/white_draught.tscn')
var black_draught_res = preload('res://Scenes/black_draught.tscn')

var turn = 1
var the_chosen_one
var is_taking: bool = false
var whites = []
var blacks = []
var to_delete: Array
var board: Array = [
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

func cells_init():
	var cells = [
		$A1, $C1, $E1, $G1,
		$B2, $D2, $F2, $H2,
		$A3, $C3, $E3, $G3,
		$B4, $D4, $F4, $H4,
		$A5, $C5, $E5, $G5,
		$B6, $D6, $F6, $H6,
		$A7, $C7, $E7, $G7,
		$B8, $D8, $F8, $H8,
	]
	var dict = {"A": 0, "B": 1, "C": 2, "D": 3, "E": 4, "F": 5, "G": 6, "H": 7,}
	for cell in cells:
		cell.pos.append(dict[cell.name.left(1)]) # X
		cell.pos.append(int(cell.name.right(1)) - 1) # Y

func print_board():
	for i in board.slice(-1, -board.size() - 1, -1):
			print(i)

func board_update():
	for i in board:
		for j in range(i.size()):
			i[j] = 0
	for w in whites:
		board[w.getY()][w.getX()] = 1
	for b in blacks:
		board[b.getY()][b.getX()] = 2
	#cells_info(cells)

func board_clear_3():
	var cells = [
		$A1, $C1, $E1, $G1,
		$B2, $D2, $F2, $H2,
		$A3, $C3, $E3, $G3,
		$B4, $D4, $F4, $H4,
		$A5, $C5, $E5, $G5,
		$B6, $D6, $F6, $H6,
		$A7, $C7, $E7, $G7,
		$B8, $D8, $F8, $H8,
	]
	
	for cell in cells:
		cell.get_active_material(0).set_feature(BaseMaterial3D.FEATURE_EMISSION, false)

func board_connect():
	var cells = [
		$A1, $C1, $E1, $G1,
		$B2, $D2, $F2, $H2,
		$A3, $C3, $E3, $G3,
		$B4, $D4, $F4, $H4,
		$A5, $C5, $E5, $G5,
		$B6, $D6, $F6, $H6,
		$A7, $C7, $E7, $G7,
		$B8, $D8, $F8, $H8,
	]
	for cell in cells:
		cell.cell_is_clicked.connect(_on_cell_input_event)

func any_take() -> bool:
	var draughts = whites if turn == 1 else blacks
	for draught in draughts:
		if get_takes(draught.getY(), draught.getX(), draught.is_black)[0][0] != -1:
			return true
	return false

func get_takes(y, x, is_black) -> Array:
	var enemies = [2, 22] if not is_black else [1, 11]
	var takes = []
	
	# TODO Обработать выход за границы доски
	if x < 6:
		if y < 6 and (board[y + 1][x + 1] in enemies) and board[y + 2][x + 2] == 0:
			takes.append([y + 2, x + 2])
		if y > 1 and (board[y - 1][x + 1] in enemies) and board[y - 2][x + 2] == 0:
			takes.append([y - 2, x + 2])
	if x > 1:
		if y < 6 and (board[y + 1][x - 1] in enemies) and board[y + 2][x - 2] == 0:
			takes.append([y + 2, x - 2])
		if y > 1 and (board[y - 1][x - 1] in enemies) and board[y - 2][x - 2] == 0:
			takes.append([y - 2, x - 2])
	if takes.is_empty():
		return[[-1, -1]]
	return takes

func get_moves(y, x, is_black) -> Array:
	var d = -1 if is_black else 1
	var moves = []
	
	# TODO Обработать выход за границы доски
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
	cells_init()
	board_update()
	board_connect()

func _process(delta: float) -> void:
	pass

func _on_draught_input_event(y, x, is_black, draught) -> void:
	print('Coords of the clicked draught are (Y: ', y, ' X: ', x, ')')
	var move_possibility: bool
	var take_possibility: bool
	
	var moves = get_moves(y, x, is_black)
	var takes = get_takes(y, x, is_black)
	move_possibility = false if moves[0][0] == -1 else true
	take_possibility = false if takes[0][0] == -1 else true
	
	print('This draught move possibility is ', move_possibility)
	print('This draught take possibility is ', take_possibility)
	
	# TODO turn control on screen
	var is_this_colour_turn = true if ((turn == 1 and !is_black) or (turn == 2 and is_black)) else false

	if is_this_colour_turn:
		if take_possibility:
			board_clear_3()
			set_moves(takes)
			the_chosen_one = draught
		elif !any_take() and move_possibility:
			board_clear_3()
			set_moves(moves)
			the_chosen_one = draught

func _on_cell_input_event(new_y, new_x, position_x, position_z) -> void:
	if the_chosen_one != null:
		var is_take = true if abs(new_x - the_chosen_one.getX()) == 2 else false
		var x_to_delete
		var y_to_delete
		
		the_chosen_one.setX(new_x)
		the_chosen_one.setY(new_y)
		the_chosen_one.position.x = position_x
		the_chosen_one.position.z = position_z
		
		if is_take:
			is_taking = true
			var d = -1 if new_x - the_chosen_one.getX() > 0 else 1
			x_to_delete = the_chosen_one.getX() + (new_x - the_chosen_one.getX() + d)
			d = -1 if new_y - the_chosen_one.getY() > 0 else 1
			y_to_delete = the_chosen_one.getY() + (new_y - the_chosen_one.getY() + d)
			board[y_to_delete][x_to_delete] = 10
			to_delete.append([y_to_delete, x_to_delete])
			
			if get_takes(the_chosen_one.getY(), the_chosen_one.getX(), the_chosen_one.is_black)[0][0] == -1:
				var draughts: Array = whites if the_chosen_one.is_black else blacks
				is_taking = false
				for draught in draughts:
					if draught.pos in to_delete:
						# print(x_to_delete, y_to_delete, the_chosen_one.getX(), the_chosen_one.getY())
						draughts.remove_at(draughts.find(draught))
						draught.queue_free()
						draught.free()
						break
				to_delete.clear()
				turn = 1 if turn == 2 else 2
				the_chosen_one = null

		board_update()
		print_board()
	board_clear_3()

func set_moves(moves):
	var dict = {0: "A", 1: "B", 2: "C", 3: "D", 4: "E", 5: "F", 6: "G", 7: "H",}
	for move in moves:
		var cell = get_node(dict[move[1]] + str(move[0] + 1))
		
		var material = cell.get_active_material(0).duplicate()
		material.set_feature(BaseMaterial3D.FEATURE_EMISSION, true)
		cell.set_surface_override_material(0, material)

func _on_draught_mouse_entered() -> void:
	pass

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	pass # Replace with function body.
