extends Node3D

@export var num_enemies: int = 10
@export var spawn_height: float = 1
@export var padding: float = 1.0 

@onready var spawner: Node3D = $Spawner
@onready var b_zone: CSGCombiner3D = $BZone

var enemy_scene: PackedScene = preload("res://Scenes/enemy.tscn")
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

	var floor_box := b_zone.get_child(0)
	var floor_size: Vector3 = floor_box.size * floor_box.global_transform.basis.get_scale()

	for _i in range(num_enemies):
		var x := rng.randf_range(-floor_size.x * 0.5 + padding, floor_size.x * 0.5 - padding)
		var z := rng.randf_range(-floor_size.z * 0.5 + padding, floor_size.z * 0.5 - padding)
		print("Enemy",_i, x,z)
		var enemy := enemy_scene.instantiate() as Node3D
		spawner.add_child(enemy)
		enemy.global_position = b_zone.global_position + Vector3(x, spawn_height, z)
