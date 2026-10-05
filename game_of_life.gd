extends Node

const GridLayout := Vector2i(95, 67)
const RandomiseGrid = true
const UpdateTick = 0.085

var write_buffer: BitMap

@onready var grid: Grid = $Grid
@onready var update_timer: Timer = $UpdateTimer


func _ready() -> void:
	State.edit_mode_changed.connect(_on_edit_mode_changed)
	write_buffer = grid.initialise(GridLayout, RandomiseGrid)
	if not RandomiseGrid:
		State.toggle_edit_mode()
	else:
		update_timer.start(UpdateTick)


func game_of_life() -> void:
	for cell: Cell in grid.get_children().slice(1):
		if cell.is_alive and cell.live_neighbour_count in [2, 3]:
			write_buffer.set_bitv(cell.location, true)
		elif not cell.is_alive and cell.live_neighbour_count == 3:
			write_buffer.set_bitv(cell.location, true)
		else:
			write_buffer.set_bitv(cell.location, false)
	grid.update_from_buffer()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_edit_mode"):
		State.toggle_edit_mode()
	elif event.is_action_pressed("clear"):
		grid.clear()
		if not State.edit_mode:
			State.toggle_edit_mode()
	elif event.is_action_pressed("randomise"):
		grid.randomise()
	elif event.is_action_pressed("quit"):
		quit()
	elif event.is_action_pressed("toggle_fullscreen"):
		toggle_fullscreen()
	else: return

	get_viewport().set_input_as_handled()


func quit() -> void:
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()


func toggle_fullscreen() -> void:
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_edit_mode_changed(edit_mode: bool) -> void:
	if edit_mode:
		update_timer.stop()
	else:
		grid.update_from_buffer()
		update_timer.start(UpdateTick)
