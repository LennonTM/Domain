extends RigidBody3D
@export var item : ItemData
@onready var detector = $Area3D
@onready var hitbox = $CollisionShape3D
@onready var timer = $Timer
func _ready():
	var inst = MeshInstance3D.new()
	inst.mesh = item.mesh
	hitbox.shape = item.mesh.create_trimesh_shape()
	add_child(inst)
	detector.monitorable = false
	detector.monitoring = false
	timer.start()
	

func _process(delta):
	for body in detector.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.inventory.add(item)
			queue_free()


func _on_timer_timeout():
	detector.monitorable = true
	detector.monitoring = true
