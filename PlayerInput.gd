extends BaseNetInput
class_name PlayerInput

var movement: Vector3
var SPEED : float = 4

func _gather():
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (get_parent().get_node("Twist").transform.basis.z * input_dir.y + Vector3(0,1,0).cross(get_parent().get_node("Twist").transform.basis.z)* input_dir.x).normalized()
	if direction:
		movement.x = direction.x * SPEED
		movement.z = direction.z * SPEED
	else:
		movement.x = move_toward(movement.x, 0, SPEED)
		movement.z = move_toward(movement.z, 0, SPEED)
