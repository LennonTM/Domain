extends Node3D

@export var detector : Area3D
@export var hit : Area3D
@export var damage : float
@export var animation : AnimationPlayer
@export var windupAnimName : String
@export var smashAnimName : String
@export var windupStream : AudioStream
@export var smashStream : AudioStream
@export var windupTime : float
@export var cooldownTime : float

@onready var windup = $Windup
@onready var cooldown = $Cooldown
@onready var windupAudio = $WindupAudio
@onready var smashAudio = $SmashAudio

func _ready():
	windupAudio.stream = windupStream
	smashAudio.stream = smashStream
	windup.wait_time = windupTime
	cooldown.wait_time = windupTime + cooldownTime

func _physics_process(delta):
	for body in detector.get_overlapping_bodies():
		if  body != null:
			if body.is_in_group("player"):
				if cooldown.time_left == 0:
					cooldown.start()
					AudioVisualWindup()
					if windup.time_left == 0:
						windup.start()

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
	

func _on_windup_timeout():
	AudioVisualSmash()
	for body in detector.get_overlapping_bodies():
		if  body != null:
			if body.is_in_group("player"):
				body.receive_damage(damage)
