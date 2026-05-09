extends ItemList

var player_list

func _ready() -> void:
	player_list = get_tree().root.get_node("Main").get_node("PlayerList");

func _process(delta: float) -> void:
	clear()
	for i in player_list.contents:
		if i == 1:
			add_item("HOST: \"" + player_list.get_username(i) + "\"")
		else:
			add_item("PLAYER: \"" + player_list.get_username(i) + "\"")
