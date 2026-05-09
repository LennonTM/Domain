extends Node

var contents = {}

@rpc("call_local")
func remove_at(peer_id):
	contents.erase(peer_id)

func get_username(peer_id) -> String:
	return contents[peer_id].username;

@rpc("any_peer")
func add(username, id):
	if !contents.has(id):
		contents[id] = {
			"username" = username
		}
	if multiplayer.is_server():
		for i in contents:
			add.rpc(contents[i].username, i )

func clear():
	contents = {}
