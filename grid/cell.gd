class_name Cell
extends Area2D

signal is_alive_changed(cell: Cell)

const FrameIndex = {false: 0, true: 3}
enum FrameOffset {Default, Hovered}

var is_alive: bool = true

var _mouse: FrameOffset = FrameOffset.Default

@onready var sprite: AnimatedSprite2D = $Sprite


func _update_sprite() -> void:
	sprite.frame = FrameIndex[is_alive] + _mouse


func _on_mouse_entered() -> void:
	_mouse = FrameOffset.Hovered
	_update_sprite()


func _on_mouse_exited() -> void:
	_mouse = FrameOffset.Default
	_update_sprite()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_alive = true
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		is_alive = false
	else: return
	_update_sprite()
	is_alive_changed.emit(self)
