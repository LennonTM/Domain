extends Label3D

@export var source: CharacterBody3D

func _process(delta: float) -> void:
	#grabs the first token of the name
	#player1 202020 gives player1
	#mob 20202 gives mob etc
	text = source.name.get_slice(" ", 0);
