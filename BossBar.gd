extends Node3D
const activationRange : int = 200
@export var text : String
@export var HP : HPComp
@onready var boss = $Boss
@onready var label = $Boss/VBoxContainer/Label
@onready var bar = $Boss/VBoxContainer/ProgressBar
	
func _ready():
	label.text = text

func _process(delta):
	var player : Player = findPlayerOf(str(multiplayer.get_unique_id()))
	if player && (player.global_position - global_position).length() < activationRange:
		bar.max_value = HP.maxValue
		bar.value = HP.value
		boss.show()
	else:
		boss.hide()

func findPlayerOf(n : String):
	for player in get_tree().get_nodes_in_group("player"):
		if player.name == n:
			return player
