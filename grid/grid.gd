class_name Grid
extends Node2D

const CellScene = preload("uid://b6sgdycytyy1a")

var _layout: Vector2i
var _write_buffer: BitMap


func initialise(layout: Vector2i, buffer: BitMap, randomise: bool = true) -> void:
	_layout = layout
	_write_buffer = buffer
	for y: int in layout.y:
		for x: int in layout.x:
			var cell: Cell = CellScene.instantiate()
			add_child(cell)
			cell.initialise(Vector2i(x, y), layout, randomise)
			cell.is_alive_changed.connect(_on_cell_is_alive_changed)
			_write_buffer.set_bitv(cell.location, cell.is_alive)
