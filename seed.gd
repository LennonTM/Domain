extends Node

var value: int;

@rpc("authority", "call_local")
func set_seed(val: int):
	value = val
	
func roll():
	set_seed.rpc(randi());
	
func _on_main_menu_seed_roll() -> void:
	roll()

@rpc("any_peer", "call_remote")
func send_seed():
	set_seed.rpc_id(multiplayer.get_remote_sender_id(), value);
	


func _on_main_menu_seed_request() -> void:
	send_seed.rpc_id(1);
