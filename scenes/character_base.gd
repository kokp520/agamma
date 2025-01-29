# CharacterBase.gd
extends Area2D

@export var speed = 400
var screen_size
var current_state = "stand"
var attack_timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	base_check()
	

func base_check() -> void:
	var animation = get_animated_sprite_2d_object()
	if animation == null:
		push_error("Critical Error: AnimatedSprite2D node missing!")
		get_tree().quit()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if attack_timer > 0:
		return
	var velocity = handle_input()
	update_position(delta, velocity)
	update_state(velocity)

	
func handle_input() -> Vector2:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	return velocity

func update_position(delta: float, velocity: Vector2) -> void:
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed	
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func update_state(v: Vector2) -> void:
	if v.length() > 0:
		set_state("run")
	elif attack_timer > 0:
		pass
	else:
		set_state("stand")

	if v.x != 0 or v.y != 0:
		var animated_sprite_2d = get_animated_sprite_2d_object()
		animated_sprite_2d.animation = "run"
		animated_sprite_2d.flip_v = false
		animated_sprite_2d.flip_h = v.x < 0
		

func set_state(new_state: String) -> void:
	current_state = new_state
	var animated_sprite_2d = get_animated_sprite_2d_object()
	animated_sprite_2d.animation = new_state
	animated_sprite_2d.play()
		
# interface
func get_animated_sprite_2d_object() -> AnimatedSprite2D:
	return null
