extends CanvasLayer

@onready var hpBAR = $Basic/PanelContainer/VBoxContainer/HealthBar3D
@onready var coolBAR = $Basic/Cooldown
@onready var sprintBar = $Basic/PanelContainer/VBoxContainer/SprintBar
@onready var Hbox = $Basic/InventoryPanel/HBoxContainer
@export var player : Player


func _ready():
	if not is_multiplayer_authority(): hide()

func _process(delta):
	if not is_multiplayer_authority(): return
	hpBAR.value = player.get_node("HPComp").value
	player.NameTag.hide()
	player.mesh.hide()
	player.HealthBar.hide()
	coolBAR.max_value = player.inventory.getCurrentAttackSpeed()
	coolBAR.value = player.inventory.getCurrentAttackSpeed() - player.cooldown.get_time_left()
	sprintBar.value = player.sprint
	for index in player.inventory.size():
		Hbox.get_node(str(index)).texture = player.inventory.getTextureAt(index)
