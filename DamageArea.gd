@tool
extends Node3D
@export var timeAlive : float = 1.79769e308 :
	get: return $Timer.get_wait_time()
	set(value): $Timer.wait_time = value
@export var damageDelay : float = 0.02 :
	get: return $Timer2.get_wait_time()
	set(value): $Timer2.wait_time = value
@export var deleteOnContact : bool = true
@export var shape : Shape3D :
	get: return $Area3D/CollisionShape3D.shape
	set(value): $Area3D/CollisionShape3D.shape = value
@export var damage : float = 30
@onready var delay = $Timer2

@onready var collider = $Area3D/CollisionShape3D
@onready var hit = $Area3D
	
func _process(delta):
	if delay.time_left == 0:
		var hitList = hit.get_overlapping_bodies()
		for body in hitList:
			if body.has_node("DamageReceiver"):
				body.get_node("DamageReceiver").apply.rpc(damage)
		if hitList.size() > 0:
			delay.start()
			if deleteOnContact:
				delete.rpc()

func _on_timer_timeout():
	delete.rpc()
	
@rpc("any_peer", "call_local")
func delete():
	queue_free()
