extends GridContainer


func _ready() -> void:
	State.edit_mode_changed.connect(func(edit_mode: bool) -> void:
		visible = edit_mode
	)
