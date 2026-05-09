extends CanvasLayer

const Player = preload("res://Player.tscn")

@onready var main_menu = $MainMenuPanel
@onready var address_entry = $MainMenuPanel/MarginContainer/VBoxContainer/AddressEntry
@onready var name_entry = $MainMenuPanel/MarginContainer/VBoxContainer/NameEntry
@onready var timeout = $TimeoutTimer
@onready var join = $MainMenuPanel/MarginContainer/VBoxContainer/JoinButton
@onready var host = $MainMenuPanel/MarginContainer/VBoxContainer/HostButton
@onready var lobby = $Lobby
@onready var start = $Lobby/StartButton
@onready var playerList = $Lobby/PanelContainer/VBoxContainer/PlayerList

var player_list

const PORT = 16942
var enet_peer = ENetMultiplayerPeer.new()
var Level

signal return_menu;
signal seed_roll;
signal seed_request;

func _ready():
	lobby.hide()
	player_list = get_tree().root.get_node("Main").get_node("PlayerList")
	Level = get_tree().root.get_node("Main").get_node("Level");

func _on_host_button_pressed():
	if enet_peer.create_server(PORT) == OK:
		start.show()
		main_menu.hide()
		lobby.show()
		multiplayer.multiplayer_peer = enet_peer
		multiplayer.peer_disconnected.connect(_remove_player)
		player_list.add(name_entry.text, multiplayer.get_unique_id());
		seed_roll.emit();
		#upnp_setup()
	else:
		OS.alert("Server creation failed", "Domain")
		enet_peer.close()

func _remove_player(peer_id):
	player_list.remove_at.rpc(peer_id)

func delete_player(peer_id):
	get_tree().get_node("Main").get_node("Level").get_node(peer_id).queue_free()

func _on_join_button_pressed():
	var address = "localhost"
	if(address_entry.text != ""):
		address = address_entry.text
	if enet_peer.create_client(address, PORT) == OK:
		multiplayer.multiplayer_peer = enet_peer
		ui_disabled(true);
		multiplayer.connected_to_server.connect(connected_to_server)
		multiplayer.connection_failed.connect(connection_failed)
		
func ui_disabled(d: bool):
	join.disabled = d;
	host.disabled = d;
	address_entry.editable = !d;
	name_entry.editable = !d;

func returnMainMenu():
	return_menu.emit()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	main_menu.show()
	lobby.hide()
	address_entry.text = ""
	player_list.clear()
	ui_disabled(false);
	if get_tree().root.has_node("Level"):
		get_tree().root.get_node("Level").queue_free()
	enet_peer.close()

@rpc("call_local", "authority")
func startGame():
	main_menu.hide()
	lobby.hide()
	Level.generate();
	
func connected_to_server():
	main_menu.hide()
	player_list.add.rpc_id(1, name_entry.text, multiplayer.get_unique_id());
	seed_request.emit()
	lobby.show()
	start.hide()
	multiplayer.server_disconnected.connect(returnMainMenu)
	
func connection_failed():
	OS.alert("Client connection failed");
	returnMainMenu()

func upnp_setup():
	pass
	##var upnp = UPNP.new()
	##var discover_result = upnp.discover()
	##assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
	###		"UPNP Discover Failed! Error %s" % discover_result)
	##assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
	##		"UPNP Invalid Gateway!")
	##var map_result = upnp.add_port_mapping(PORT)
	##assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
	##		"UPNP Port Mapping Failed! Error %s" % map_result)


func _on_start_button_pressed():
	startGame.rpc()


func _on_leave_button_pressed():
	returnMainMenu()


func _on_roll_pressed() -> void:
	if not multiplayer.is_server(): return
	seed_roll.emit()
