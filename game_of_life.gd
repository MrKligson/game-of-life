extends Node

const GridLayout := Vector2i(95, 67)
const RandomiseGrid = true
const UpdateTick = 0.085

var write_buffer := BitMap.new()

@onready var grid: Grid = $Grid
@onready var update_timer: Timer = $UpdateTimer


func _ready() -> void:
	write_buffer.create(GridLayout)
	grid.initialise(GridLayout, write_buffer, RandomiseGrid)
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
