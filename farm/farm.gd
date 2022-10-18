extends Node2D

func _ready():
	$spawn_timer.connect("timeout", self, "_spawn")

func _spawn():
	if $animals.get_child_count() < 3:
		var scene := preload("res://farm/cow.tscn")
		var animal := scene.instance()
		var spawn_point: Position2D = $spawn_points.get_children()[randi() % $spawn_points.get_child_count()]
		animal.position = spawn_point.position
		$animals.add_child(animal)
