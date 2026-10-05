extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	State.edit_mode_changed.connect(_set_text)
	_set_text(State.edit_mode)


func _set_text(edit_mode: bool) -> void:
	text = "RUN" if edit_mode else "EDIT"
