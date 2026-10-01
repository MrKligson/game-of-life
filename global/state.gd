extends Node

signal edit_mode_changed(edit_mode: bool)

var edit_mode: bool:
	get: return _edit_mode
	set(v): assert(false, "Global.State.edit_mode: Don't set this directly. Use my methods.")

var _edit_mode: bool = false

func toggle_edit_mode() -> void:
	_edit_mode = not _edit_mode
	edit_mode_changed.emit(_edit_mode)
