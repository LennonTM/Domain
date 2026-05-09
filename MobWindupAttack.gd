extends Node3D

@export var detector : Area3D
@export var hit : Area3D
@export var damage : float
@export var animation : AnimationPlayer
@export var windupAnimName : String
@export var smashAnimName : String
@export var releaseAnimName : String
@export var windupStream : AudioStream
@export var smashStream : AudioStream
@export var cooldownTime : float

@onready var cooldown = $Cooldown
@onready var windupAudio = $WindupAudio
@onready var smashAudio = $SmashAudio


var attacking : bool = false

func _ready():
	windupAudio.stream = windupStream
	smashAudio.stream = smashStream
	cooldown.wait_time = cooldownTime
	animation.animation_finished.connect(AnimationFinished)

func _physics_process(delta):
	for body in detector.get_overlapping_bodies():
		if  body != null:
			if body.is_in_group("player"):
				if cooldown.time_left == 0 && attacking == false:
					attacking = true
					AudioVisualWindup()

@rpc("call_local")
func AudioVisualSmash():
	smashAudio.global_position = global_position
	smashAudio.play()
	animation.stop()
	animation.play(smashAnimName)
	
@rpc("call_local")
func AudioVisualWindup():
	windupAudio.global_position = global_position
	windupAudio.play()
	animation.stop()
	animation.play(windupAnimName)
	

func AnimationFinished(animName):
	if animName ==windupAnimName:
		AudioVisualSmash()
	if animName==smashAnimName:
		for body in hit.get_overlapping_bodies():
			if  body != null:
				if body.has_node("DamageReceiver"):
					body.get_node("DamageReceiver").apply.rpc(damage)
		cooldown.start()
		attacking = false
		animation.play(releaseAnimName)
