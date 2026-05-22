extends CharacterBody3D


@onready var animated_sprite_2d: AnimatedSprite2D = $CanvasLayer/GunBase/AnimatedSprite2D
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

#Player settings
@export var SPEED = 15.0
@export var MOUSE_SENS = 0.5
@export var MAX_PITCH := 89.0
@export var JUMP_VELOCITY = 8.0
@export var current_jumps_limit = 2.0
@export var total_jumps = 2.0

#dash
@export var dash_speed := 50.0
@export var dash_time := 0.10
@export var can_dash := true
var tween: Tween
var dash_dir := Vector3.ZERO
var is_dashing := false
var dash_timer := 0.0

#Bullet
@export var current_weapon = "HAND"
@export var bullet_scene: PackedScene
@export var bullet_spawn_offset := Vector3(0, 0, -1) 
@export var bullet_speed := 20.0
const BULLET_SAMPLE = preload("res://Scenes/Bullets/bullet_sample.tscn")

#Camera movement



var can_shoot = true
var dead = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var pitch := 0.0  


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animated_sprite_2d.animation_finished.connect(shoot_anim_done)
	$CanvasLayer/DeathScreen/Panel/Button.button_up.connect(restart)


func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENS
		pitch -= event.relative.y * MOUSE_SENS
		pitch = clamp(pitch, -MAX_PITCH, MAX_PITCH)
		rotation_degrees.x = pitch
		
	
		
		
func _process(delta):
	if is_on_floor():
		current_jumps_limit = total_jumps
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
		
	if dead:
		return
		
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("jump") and current_jumps_limit > 0:
		jump()
	if Input.is_action_just_pressed("dash"):
		dash()
		
		
func restart():
	get_tree().reload_current_scene()
	


func _physics_process(delta: float) -> void:
	if dead: return
	
	if not is_on_floor():
		velocity.y -= (20.0) * delta
		
	if is_dashing:
		dash_timer -= delta
		velocity.x = dash_dir.x * dash_speed
		velocity.z = dash_dir.z * dash_speed

		if dash_timer <= 0.0:
			is_dashing = false
			
		move_and_slide()
		return
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	
func shoot():
	if !can_shoot:
		return
	can_shoot = false
	animated_sprite_2d.play("shoot") #should be shoot animation
	if current_weapon == "HAND":
		animated_sprite_2d.animation_finished.connect(hand_bullet)
	
	
func hand_bullet():
	var bullet: RigidBody3D = BULLET_SAMPLE.instantiate()

	var cam := $Head/Camera3D
	var forward = -cam.global_transform.basis.z

	bullet.global_position = cam.global_position + forward * 2.5
	get_tree().current_scene.add_child(bullet)

	bullet.linear_velocity = forward * bullet_speed
	

func shoot_anim_done():
	can_shoot = true
	animated_sprite_2d.play("idle")
	
	
func jump():
	velocity.y = JUMP_VELOCITY
	current_jumps_limit -= 1
	
func dash():
	if not can_dash: return
	var input_dir := Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	if input_dir == Vector2.ZERO:
		input_dir = Vector2(0, -1)
	dash_dir = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	
	is_dashing = true
	dash_timer = dash_time

	
func kill():
	dead = true
	$CanvasLayer/DeathScreen.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
