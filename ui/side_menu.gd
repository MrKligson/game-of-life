extends PanelContainer


@onready var grid: Grid = %Grid
@onready var run_edit_button: Button = %RunEditButton
@onready var clear_button: Button = %ClearButton
@onready var randomise_button: Button = %RandomiseButton
@onready var fullscreen_button: Button = %FullscreenButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	run_edit_button.pressed.connect(State.toggle_edit_mode)
	clear_button.pressed.connect(grid.clear)
	randomise_button.pressed.connect(grid.randomise)
	fullscreen_button.pressed.connect(toggle_fullscreen)
	quit_button.pressed.connect(quit)


func quit() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
