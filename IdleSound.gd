extends Node3D
@export var stream : AudioStream
@onready var audio = $IdleAudio

func _ready():
	audio.stream = stream
	
func _physics_process(delta):
	if !audio.playing:
		PlaySound()

@rpc("call_local")
func PlaySound():
	audio.global_position = global_position
	audio.play()
