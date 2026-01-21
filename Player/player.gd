extends CharacterBody2D


var movement_speed = 80.0
var hp_max = 10
var hp = 10

#Attacks
var shot = preload("res://Player/Attack/shot.tscn")
@onready var game_over_scene = preload("res://World/game_over.tscn")  # Caminho para a cena de Game Over


#AttacksNodes
@onready var shotTimer = get_node("%shotTimer")
@onready var shotAttackTimer = get_node("%shotAttackTimer")

#Shot
var shot_ammo = 0
var shot_baseammo = 1
var shot_attackspeed = 1.5
var shot_level = 1

#Enemy Related
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("walkTimer")

func _ready() -> void:
	attack()

func _physics_process(_delta: float):
	movement()

func _process(delta: float) -> void:
	if hp <= 0:
		game_over()

func attack():
	if shot_level > 0:
		shotTimer.wait_time = shot_attackspeed
		if shotTimer.is_stopped():
			shotTimer.start()
	
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false
	
	if mov != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
		
	velocity = mov.normalized()*movement_speed
	move_and_slide()


func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	print(hp)


func _on_shot_timer_timeout() -> void:
	shot_ammo += shot_baseammo
	shotAttackTimer.start()
	


func _on_shot_attack_timer_timeout() -> void:
	if shot_ammo > 0:
		var shot_attack = shot.instantiate()
		shot_attack.position = position
		shot_attack.target = get_random_target()
		shot_attack.level = shot_level
		add_child(shot_attack)
		shot_ammo -= 1
		if shot_ammo > 0:
			shotAttackTimer.start()
			
		else:
			shotAttackTimer.stop()
		
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
		

func game_over():
	var game_over_instance = game_over_scene.instantiate()
	get_tree().current_scene.add_child(game_over_instance)
	queue_free()
	
