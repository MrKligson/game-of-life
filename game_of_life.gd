extends Node

const GridLayout := Vector2i(95, 67)
const RandomiseGrid = true

var write_buffer := BitMap.new()

@onready var grid: Grid = $Grid


func _ready() -> void:
	write_buffer.create(GridLayout)
	grid.initialise(GridLayout, write_buffer, RandomiseGrid)
	if not RandomiseGrid:
		State.toggle_edit_mode()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_edit_mode"):
		State.toggle_edit_mode()
