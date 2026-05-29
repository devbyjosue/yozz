extends Node3D

@onready var anim: AnimatedSprite3D = $AnimatedSprite3D
@onready var laser_root: Node3D = $LaserGun
@onready var ray: RayCast3D = $LaserGun/Laser/RayCast3D
@onready var beam_pivot: Node3D = $LaserGun/Laser/BeamPivot
@onready var beam: MeshInstance3D = $LaserGun/Laser/BeamPivot/Beam

@export var max_distance: float = 15.0
@export var beam_width: float = 0.1
@export var beam_height: float = 0.1

var last_hit: Object = null
var laser_on := false

func _ready() -> void:
	laser_root.visible = false
	ray.enabled = false
	anim.play("idle")

func shoot() -> void:
	if laser_on:
		return
	laser_on = true
	laser_root.visible = true
	ray.enabled = true
	anim.play("fire")

func stop_shoot() -> void:
	if !laser_on:
		return
	laser_on = false
	laser_root.visible = false
	ray.enabled = false
	anim.play("idle")

func _physics_process(_delta: float) -> void:
	if !laser_on:
		last_hit = null
		return

	ray.target_position = Vector3(-0.9, 0.9, -max_distance)
	ray.force_raycast_update()

	var forward := -ray.global_transform.basis.z
	var start := ray.global_position + forward * 0.1
	
	var end := ray.to_global(ray.target_position)
	var hit : Object = null
	
	if ray.is_colliding():
		end = ray.get_collision_point()
		hit = ray.get_collider()
	
		
	if hit != null and hit != last_hit:
		if hit.has_method("kill"):
			hit.call_deferred("kill")
	
	last_hit = hit
	

	_update_beam_from_to(start, end)

func _update_beam_from_to(start: Vector3, end: Vector3) -> void:
	var length := start.distance_to(end)

	beam_pivot.global_position = start
	beam_pivot.look_at(end, Vector3.UP)

	beam.position = Vector3(0, 0, -length * 0.5)

	beam.scale = Vector3(beam_width, beam_height, length)
