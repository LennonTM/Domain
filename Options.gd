extends CanvasLayer

@onready var options = $OptionsPanel
@onready var sens_slider = $OptionsPanel/MarginContainer/VBoxContainer/SensSlider
@onready var sens_label = $OptionsPanel/MarginContainer/VBoxContainer/SensLabel
@onready var fov_slider = $OptionsPanel/MarginContainer/VBoxContainer/FOVSlider
@onready var fov_label = $OptionsPanel/MarginContainer/VBoxContainer/FOVLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	options.hide()
	sens_slider.value = Level.sens
	fov_slider.value = Level.FOV
	sens_label.text = "Sensitivity : " + str(sens_slider.value)
	fov_label.text = "FOV : " + str(fov_slider.value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")):		
		if(options.visible):
			options.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			options.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if(Level.sens != float(sens_slider.value)):
		sens_label.text = "Sensitivity : " + str(sens_slider.value)
		Level.sens = float(sens_slider.value)
	if(Level.FOV != float(fov_slider.value)):
		fov_label.text = "FOV : " + str(fov_slider.value)
		Level.FOV = float(fov_slider.value)
		
		
	
