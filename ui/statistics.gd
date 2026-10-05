class_name Statistics
extends GridContainer

var cell_count: int
var generation: int
var survived: int
var born: int
var died: int

@onready var cell_count_label: Label = %CellCount
@onready var generation_label: Label = %Generation
@onready var living_label: Label = %Living
@onready var survived_label: Label = %Survived
@onready var born_label: Label = %Born
@onready var died_label: Label = %Died


func initialise(grid_layout: Vector2i) -> Statistics:
	cell_count = grid_layout.x * grid_layout.y
	generation = 0
	return self


func update() -> void:
	cell_count_label.text = str(cell_count)
	generation_label.text = str(generation)
	living_label.text = str(survived + born)
	survived_label.text = str(survived)
	born_label.text = str(born)
	died_label.text = str(died)


func reset() -> void:
	next_generation()
	generation = 0
	update()


func next_generation() -> void:
	generation += 1
	survived = 0
	born = 0
	died = 0
