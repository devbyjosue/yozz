extends Node3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var cam: Camera3D = owner.get_node("Head/Camera3D") as Camera3D
@export var bullet_scene: PackedScene = preload("res://Scenes/Bullets/bullet_sample.tscn")
@export var bullet_speed = 20.0 
@export var bullet_spawn_distance: float = 2.5


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func shoot():
	animated_sprite_3d.play("fire")
	if !animated_sprite_3d.animation_finished.is_connected(_spawn_bullet):
		animated_sprite_3d.animation_finished.connect(_spawn_bullet)
	
	
func _spawn_bullet():
	if !is_inside_tree():
		return
	var bullet := bullet_scene.instantiate() as RigidBody3D
	var forward := -cam.global_transform.basis.z
	bullet.global_position = cam.global_position + forward * bullet_spawn_distance

	get_tree().current_scene.add_child(bullet)
	bullet.linear_velocity = forward * bullet_speed
	
