extends GridContainer


func _ready() -> void:
	State.edit_mode_changed.connect(func(show: bool) -> void:
		visible = show
	)
