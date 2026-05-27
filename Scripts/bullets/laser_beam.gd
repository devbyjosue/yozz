extends Area3D

@export var damage := 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	elif body.has_method("kill"):
		body.kill()

	queue_free()
