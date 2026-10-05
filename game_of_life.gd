extends Node

const GridLayout := Vector2i(95, 67)
const RandomiseGrid = true
const UpdateTick = 0.085

var write_buffer: BitMap
var statistics: Statistics = Statistics.new()

@onready var background: Panel = $Background
@onready var grid: Grid = $Grid
@onready var update_timer: Timer = $UpdateTimer


func _ready() -> void:
	State.edit_mode_changed.connect(_on_edit_mode_changed)
	write_buffer = grid.initialise(GridLayout, RandomiseGrid)
	background.size = grid.size + Vector2i(6, 6)
	statistics.reset()
	if not RandomiseGrid:
		State.toggle_edit_mode()
	else:
		update_timer.start(UpdateTick)


func game_of_life() -> void:
	statistics.next_generation()
	for cell: Cell in grid.get_children():
		if cell.is_alive and cell.live_neighbour_count in [2, 3]:
			write_buffer.set_bitv(cell.location, true)
			statistics.survived += 1
		elif not cell.is_alive and cell.live_neighbour_count == 3:
			write_buffer.set_bitv(cell.location, true)
			statistics.born += 1
		else:
			write_buffer.set_bitv(cell.location, false)
			if cell.is_alive:
				statistics.died += 1
	grid.update_from_buffer()


func _on_edit_mode_changed(edit_mode: bool) -> void:
	if edit_mode:
		update_timer.stop()
	else:
		grid.update_from_buffer()
		update_timer.start(UpdateTick)
