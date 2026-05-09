extends PanelContainer

@onready var options = $CanvasLayer2/Options
@onready var sens_entry = $VBoxContainer/SensEntry
@onready var sens_label = $VBoxContainer/SensLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	options.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_focus_next")):		
		if(options.visible):
			options.hide()
		else:
			options.show()
		
	
