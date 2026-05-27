extends Node3D

@onready var anim: AnimatedSprite3D = $AnimatedSprite3D
@onready var laser_root: Node3D = $LaserGun
@onready var beam: MeshInstance3D = $LaserGun/Laser/Beam
@onready var ray: RayCast3D = $LaserGun/Laser

@export var beam_radius: float = 10.0

var laser_on := false

func _ready() -> void:
	laser_root.visible = false
	ray.enabled = false
	anim.play("idle")

func shoot() -> void:
	if !laser_on:
		laser_on = true
		laser_root.visible = true
		ray.enabled = true
		anim.play("fire") 

func stop_shoot() -> void:
	if laser_on:
		laser_on = false
		laser_root.visible = false
		ray.enabled = false
		anim.play("idle")

func _physics_process(_delta: float) -> void:
	if !laser_on:
		return

	ray.force_raycast_update()

	var start := ray.global_position
	var end := ray.to_global(ray.target_position) 

	#if ray.is_colliding():
		 #var hit := ray.get_collider()
		 ##If you want instant kill instead:
		 #hit.kill()

	_update_beam(start, end)

func _update_beam(start: Vector3, end: Vector3) -> void:
	var mid := (start + end) * 0.5
	var length := start.distance_to(end)

	beam.global_position = mid
	beam.look_at(end, Vector3.UP)
	beam.scale = Vector3(beam_radius, beam_radius, length)
