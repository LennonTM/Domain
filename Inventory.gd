extends  Node3D
class_name Inventory
const nullItem = preload("res://Item/Nothing.tres")

var arr = [nullItem,nullItem,nullItem,nullItem,nullItem,nullItem,nullItem,nullItem,nullItem,nullItem]
var Index =0
@onready var timer = $Timer
@onready var meshInst = $MeshInstance3D

func _process(delta):
	if getCurrentAttackSpeed() != timer.wait_time:
		timer.wait_time = getCurrentAttackSpeed()
		timer.start()
	meshInst.mesh = arr[Index].mesh
	for num in range(11):
		if Input.is_action_just_pressed(str(num)):
			Index = fposmod(num-1, 10)
			

func getAt(index):
	return arr[index]

func getCurrent():
	return arr[Index]
	
func getTextureAt(index):
	return arr[index].texture
	
func getCurrentTexture():
	return arr[Index].texture
	
func getCurrentAttackSpeed():
	return arr[Index].attackSpeed
	
func getCurrentDamage():
	return arr[Index].damage

func size():
	return arr.size()

func add(toAdd):
	for i in arr.size():
		if arr[i] == nullItem:
			arr[i] = toAdd
			return

func removeAt(index):
	arr[index] = nullItem

@rpc("any_peer", "call_local")
func dropCurrent():
	var pickup = load("res://pick_up.tscn").instantiate()
	pickup.global_position = global_position
	pickup.item = arr[Index]
	get_tree().root.get_node("Level").add_child(pickup)
	arr[Index] = nullItem
