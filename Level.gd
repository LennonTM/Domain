extends Node3D

#var sens : float = 1
#var FOV = 75
#@export var gameStarted : bool = false
var rng = RandomNumberGenerator.new()

const MAX_MOBS = 20

var player_list
var seed

@onready var map = $EndlessTerrain
	

func _ready() -> void:
	player_list = get_tree().root.get_node("Main").get_node("PlayerList")
	seed = get_tree().root.get_node("Main").get_node("Seed");
	
func generate():
	map.generate(seed.value);
	
func _on_timer_timeout():
	if multiplayer.is_server() && countMobs() < MAX_MOBS:
		var mob = preload("res://mob.tscn").instantiate()
		mob.position = Vector3(rng.randf_range(-150.0, 150.0),40,rng.randf_range(-150.0, 150.0))
		var randname = str(rng.randi())
		while(has_node(randname)):
			randname = str(rng.randi())
		mob.name = randname
		add_child(mob)

func countMobs():
	var counter = 0
	for obj in get_children():
		if obj.is_in_group("mob"):
			counter+=1
	return counter

func add_players():
	if not multiplayer.is_server(): return
	for peer_id in player_list.contents:
		var player = load("res://Player.tscn").instantiate();
		var username = player_list.get_username(peer_id);
		if username == "":
			username = "Unnamed"
		player.name = username + " " + str(peer_id);
		var pos_new = Vector3(0,map.get_height(0,0),0);
		pos_new.y += 1;
		player.position = pos_new;
		add_child(player);
		map.assign_viewer.rpc_id(peer_id, player.name);

func _on_endless_terrain_generation_initiliased() -> void:
	add_players();
