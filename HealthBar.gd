extends Node3D
@export var HP : HPComp
@onready var bar = $SubViewport/HealthBar3D
@onready var sub = $SubViewport

func _process(delta):
	if HP:
		bar.max_value = HP.maxValue		
		scale = Vector3(1,1,1) * bar.max_value / 100.0
		bar.value = HP.value
