extends Control
var PlayersLeft = []
var index : int = 0
@onready var specLabel = $Spectating/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	find_players_left()
	if PlayersLeft.size() > 0:
		if index >= PlayersLeft.size():
			index = PlayersLeft.size() - 1
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		PlayersLeft[index].camera.current = true
		specLabel.text = "SPECTATING: " + PlayersLeft[index].NameTag.text

func find_players_left():
	PlayersLeft = []
	for player in get_tree().get_nodes_in_group("player"):
		PlayersLeft.append(player)

func _on_right_pressed():
	index+= 1
	if index >= PlayersLeft.size():
		index = 0


func _on_left_pressed():
	index-=1
	if index < 0:
		index = PlayersLeft.size() - 1
