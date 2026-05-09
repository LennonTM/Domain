extends Control
	
var port := 9999
var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	pass
@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://Level.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_join_button_down():
	peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = peer

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	

func _on_host_button_down():
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
