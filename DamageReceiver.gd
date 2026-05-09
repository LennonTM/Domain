extends Node3D
@export var HealthComp : HPComp
@export var ParticleMesh : Mesh
@onready var particles = $GPUParticles3D

func _ready():
	particles.draw_pass_1 = ParticleMesh

@rpc("any_peer", "call_local")
func apply(damage):
	if HealthComp:
		particles.emitting = true
		HealthComp.sub(damage)
		if HealthComp.getValue()<=0:
			get_parent().queue_free()
