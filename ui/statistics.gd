class_name Statistics
extends RefCounted

var cell_count: int
var generation: int
var survived: int
var born: int
var died: int


func reset() -> void:
	generation = 0


func next_generation() -> void:
	generation += 1
	survived = 0
	born = 0
	died = 0
