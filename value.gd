extends Label

var seed

func _ready() -> void:
	seed = get_tree().root.get_node("Main").get_node("Seed");
	
func _process(delta: float) -> void:
	text = str(seed.value)
