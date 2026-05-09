extends Node3D
class_name HPComp
@export var value : float
@export var maxValue : float

func setTo(temp):
	value = temp

func sub(temp):
	value -=temp

func getValue():
	return value
