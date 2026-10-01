class_name Grid
extends Node2D

const CellScene = preload("uid://b6sgdycytyy1a")

var _layout: Vector2i
var _write_buffer: BitMap

@onready var panel: Panel = $Panel


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
	update_from_buffer()
	panel.size = layout * (get_child(1) as Cell).size + Vector2i(6, 6)


func update_from_buffer() -> void:
	get_tree().call_group("cells", "update", [_write_buffer])


func _on_cell_is_alive_changed(cell: Cell) -> void:
	_write_buffer.set_bitv(cell.location, cell.is_alive)
