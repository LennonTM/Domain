extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide();
	multiplayer.connected_to_server.connect(hide);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(0.01);	


func _on_join_button_pressed() -> void:
	show();

func _on_main_menu_return_menu() -> void:
	hide();
