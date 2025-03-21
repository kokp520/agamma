extends "res://scenes/character_base.gd"

enum PlayerState{
	STAND,
	RUN,
	ATTACK_1_LEFT,
	ATTACK_1_RIGHT
}

var state_animation_map: Dictionary = {
	PlayerState.STAND : "stand",
	PlayerState.RUN : "run",
	PlayerState.ATTACK_1_LEFT : "attack_1_left",
	PlayerState.ATTACK_1_RIGHT : "attack_1_right"
}

var attack_duration: float = 0.9  # 攻擊持續時間（秒）

func _ready() -> void:
	super._ready()
	speed = 1000

func _process(delta: float) -> void:
	super._process(delta)
	var attack_state = get_attack_direction(get_animated_sprite_2d_object())
	# 處理攻擊輸入
	if Input.is_action_pressed("move_attack_1") and current_state != state_animation_map[attack_state]:
		start_attack()

	# 如果處於攻擊狀態，更新計時並結束攻擊
	if current_state == state_animation_map[attack_state]:
		attack_timer -= delta
		if attack_timer <= 0:
			end_attack()

func get_animated_sprite_2d_object() -> AnimatedSprite2D:
	return $AnimatedSprite2D

# 開始攻擊
func start_attack() -> void:
	var sprite = get_animated_sprite_2d_object()
	var state = get_attack_direction(sprite)
	attack_timer = attack_duration  # 初始化攻擊計時器
	if state == PlayerState.ATTACK_1_LEFT:
		sprite.animation = 'attack_1_left'
		sprite.flip_h = true
		sprite.flip_v = false
		#sprite.scale.x = -1
	set_state(state_animation_map[state])
	

# 結束攻擊，回到站立或其他狀態
func end_attack() -> void:
	set_state(state_animation_map[PlayerState.STAND])

func get_attack_direction(sprite: AnimatedSprite2D) -> PlayerState:
	return PlayerState.ATTACK_1_LEFT if sprite.flip_h else PlayerState.ATTACK_1_RIGHT
	
