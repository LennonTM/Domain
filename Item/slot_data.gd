extends Resource
class_name SlotData
const MAX_STACK_SIZE = 64
@export var itemData : ItemData = preload("res://Item/Nothing.tres")
@export_range(1,MAX_STACK_SIZE) var amount : int = 1
