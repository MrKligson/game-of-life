class_name Grid
extends Node2D

const CellScene = preload("uid://b6sgdycytyy1a")

var size: Vector2i:
	get:
		return _layout * (get_child(1) as Cell).size

var _write_buffer := BitMap.new()
var _layout: Vector2i

@onready var background: Panel = $Background


func initialise(layout: Vector2i, random: bool = true) -> BitMap:
	_layout = layout
	_write_buffer.create(layout)
	for y: int in layout.y:
		for x: int in layout.x:
			var cell: Cell = CellScene.instantiate()
			add_child(cell)
			cell.initialise(Vector2i(x, y), layout, random)
			cell.is_alive_changed.connect(_on_cell_is_alive_changed)
			_write_buffer.set_bitv(cell.location, cell.is_alive)
	update_from_buffer()
	background.size = size + Vector2i(6, 6)
	return _write_buffer


func clear() -> void:
	_write_buffer.create(_layout)
	update_from_buffer()


func randomise() -> void:
	for cell: Cell in get_children().slice(1):
		cell.randomise()
		_write_buffer.set_bitv(cell.location, cell.is_alive)
	update_from_buffer()


func update_from_buffer() -> void:
	get_tree().call_group("cells", "update", [_write_buffer])


func _on_cell_is_alive_changed(cell: Cell) -> void:
	_write_buffer.set_bitv(cell.location, cell.is_alive)
