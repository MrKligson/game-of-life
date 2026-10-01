class_name Cell
extends Area2D

signal is_alive_changed(cell: Cell)

const FrameIndex = {false: 0, true: 3}
enum FrameOffset {Default, Hovered}

var is_alive: bool = true:
	set(value):
		is_alive = value
		_update_sprite()
var location: Vector2i
var live_neighbour_count: int = 0

var _mouse: FrameOffset = FrameOffset.Default:
	set(value):
		_mouse = value
		_update_sprite()
var _neighbours: Array[Vector2i]

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $Shape


func _ready() -> void:
	State.edit_mode_changed.connect(_on_edit_mode_changed)
	# call it once to make sure our connections are good for the default:
	_on_edit_mode_changed(State.edit_mode)


func initialise(p_location: Vector2i, grid: Vector2i, random: bool) -> void:
	var size: int = collision_shape.shape.get_rect().size.x as int
	location = p_location
	position = location * size

	if random:
		is_alive = _random()
	else:
		is_alive = false

	for neighbour: Vector2i in [
			Vector2i(-1,-1), Vector2i(0, -1), Vector2i(1, -1),
			Vector2i(-1, 0), Vector2i(1, 0),
			Vector2i(-1, 1), Vector2i(0,1), Vector2i(1,1),
	]:
		_neighbours.append((location + neighbour + grid) % grid)


func update(args: Array[BitMap]) -> void:
	var cells: BitMap = args[0]
	is_alive = cells.get_bitv(location)
	live_neighbour_count = 0
	for neighbour: Vector2i in _neighbours:
		live_neighbour_count += 1 if cells.get_bitv(neighbour) else 0


func _update_sprite() -> void:
	sprite.frame = FrameIndex[is_alive]
	if State.edit_mode:
		sprite.frame += _mouse


func _random() -> bool:
	return randf() < 0.5


func _on_edit_mode_changed(edit_mode: bool) -> void:
	if edit_mode and not input_event.is_connected(_on_input_event):
		input_event.connect(_on_input_event)
	elif not edit_mode and input_event.is_connected(_on_input_event):
		input_event.disconnect(_on_input_event)
	_update_sprite()


func _on_mouse_entered() -> void:
	_mouse = FrameOffset.Hovered


func _on_mouse_exited() -> void:
	_mouse = FrameOffset.Default


func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_alive = true
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		is_alive = false
	else: return
	is_alive_changed.emit(self)
