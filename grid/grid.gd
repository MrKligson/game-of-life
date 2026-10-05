class_name Grid
extends Node2D

const CellScene = preload("uid://b6sgdycytyy1a")

var size: Vector2i:
	get:
		return _layout * (get_child(0) as Cell).size

var _statistics: Statistics

var _write_buffer := BitMap.new()
var _layout: Vector2i


func initialise(layout: Vector2i, statistics: Statistics, random: bool = true) -> BitMap:
	_layout = layout
	_write_buffer.create(layout)
	_statistics = statistics
	for y: int in layout.y:
		for x: int in layout.x:
			var cell: Cell = CellScene.instantiate()
			add_child(cell)
			cell.initialise(Vector2i(x, y), layout, random)
			cell.is_alive_changed.connect(_on_cell_is_alive_changed)
			_write_buffer.set_bitv(cell.location, cell.is_alive)
	update_from_buffer()
	return _write_buffer


func clear() -> void:
	_statistics.reset()
	_write_buffer.create(_layout)
	update_from_buffer()
	if not State.edit_mode:
		State.toggle_edit_mode()


func randomise() -> void:
	_statistics.reset()
	for cell: Cell in get_children():
		cell.randomise()
		_write_buffer.set_bitv(cell.location, cell.is_alive)
		_statistics.born += 1 if cell.is_alive else 0
	update_from_buffer()
	_statistics.update()



func update_from_buffer() -> void:
	get_tree().call_group("cells", "update", [_write_buffer])


func _on_cell_is_alive_changed(cell: Cell) -> void:
	_write_buffer.set_bitv(cell.location, cell.is_alive)
