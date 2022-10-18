extends Area2D

enum State {WALKING, IDLING, JUMPING}

var state: int = State.WALKING
var remaining_time := INF
var velocity := Vector2.ZERO
var orig_y := 0.0

func _ready():
	connect("input_event", self, "_on_input_event")
	$visibility_notifier_2d.connect("screen_exited", self, "queue_free")
	
	start_walking(1.0 if position.x < get_viewport().size.x / 2.0 else -1.0, 8.0)

func start_walking(direction: float, duration: float):
	state = State.WALKING
	velocity = Vector2(direction * rand_range(30.0, 60.0), 0.0)
	$sprite.flip_h = velocity.x < 0.0
	remaining_time = duration

func _process(delta: float):
	position += delta * velocity
	var target_rotation := rotation
	match state:
		State.WALKING:
			target_rotation = 0.05 * sin(5.0 * remaining_time)
		State.IDLING:
			target_rotation = 0.0
		State.JUMPING:
			velocity.y += 200.0 * delta
			target_rotation = 0.1 * Vector2(abs(velocity.x), velocity.y).angle() * sign(velocity.x)
			if position.y >= orig_y:
				position.y = orig_y
				remaining_time = 0
	rotation = lerp_angle(rotation, target_rotation, pow(0.5, 0.01 / delta))
	
	remaining_time -= delta
	if remaining_time <= 0:
		var next_state := state
		while next_state == state:
			next_state = [State.WALKING, State.IDLING, State.JUMPING][randi() % 3]
		state = next_state
		
		match state:
			State.WALKING:
				start_walking(randi() % 2 * 2.0 - 1.0, rand_range(3.0, 6.0))
			State.IDLING:
				velocity = Vector2.ZERO
				remaining_time = rand_range(1.0, 2.0)
			State.JUMPING:
				orig_y = position.y
				velocity = Vector2(sign(velocity.x) * rand_range(100.0, 200.0), -rand_range(50.0, 150.0))
				remaining_time = INF

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed and not $sound.playing:
		$sound.play()
