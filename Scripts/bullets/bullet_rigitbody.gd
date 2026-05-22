extends RigidBody3D

@export var speed = 50.0
@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)
	
	sleeping = false
	animated_sprite_3d.play("idle")
	await get_tree().create_timer(3.0).timeout
	queue_free()


#func _process(delta: float) -> void:
	#linear_velocity = -transform.basis.z * speed

func _on_body_entered(body: Node) -> void:
	if body.has_method("kill"):
		body.kill()
	queue_free()

func _physics_process(_delta):
	pass
	#print(global_position)
