extends CharacterBody3D
class_name Player

@onready var camera = $Head/Camera3D
@onready var NameTag = $NameTag
@onready var hitbox = $CollisionShape3D
@onready var ray = $Head/RayCast3D
@onready var bonk = $Bonk
@onready var mesh = $MeshInstance3D
#@onready var hit_sound = $Twist/Pitch/stick/HitSound
@onready var circ = $GPUParticles3D
@onready var HealthBar = $HealthBar
@onready var Inventory = $Head/Inventory
@onready var sync = $mul
@onready var cooldown = $Head/Inventory/Timer
@export var inventory : Inventory
var SPEED : float = 4
const JUMP_VELOCITY = 7
#var Inventory = [load("res://stick.tscn"),null,null,null,null,null,null,null,null,null]
#var Index =0
var sprint:float = 50

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	if not is_multiplayer_authority(): return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true

func _enter_tree():
	var token_2 = name.get_slice(" ", 1);
	var id = token_2.to_int();
	set_multiplayer_authority(id);

	
func _process(delta):
	if not is_multiplayer_authority(): return
	#if Inventory[Index] != null:
	#	var item = Inventory[Index].instantiate()
	#	item.position = Vector3(0.5,0,-0.5)
	#	get_node("Twist/Inventory").add_child(item)
	#else:
	#	for child in get_node("Twist/Inventory").get_children():
	#		child.queue_free()
		
	#for num in range(11):
		#if Input.is_action_just_pressed(str(num)):
		#	Index = num - 1
	if cooldown.time_left == 0:
		if Input.is_action_just_pressed("mouse1"):
			cooldown.start()
			if RandomNumberGenerator.new().randi_range(0,1) == 1:
				Poke.rpc()
			else:
				Sweep.rpc()
			if ray.is_colliding():
				var mob = ray.get_collider()
				if mob.has_node("DamageReceiver"):
					circ.global_position = ray.get_collision_point() #+ ray.get_collision_normal()
					circ.emitting = true
					#create_hit_sound.rpc(poi)
					mob.get_node("DamageReceiver").apply.rpc(Inventory.getCurrentDamage())
	if Input.is_action_just_pressed("drop"):
		inventory.dropCurrent.rpc()
	
#@rpc("call_local")
#func create_hit_sound(collision_point):
	#hit_sound.global_position = collision_point
	#hit_sound.play()


func _input(event):
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			camera.fov = 90
			var sens = 1
			rotate_y(-event.relative.x*sens*0.001)
			$Head.rotate_x(-event.relative.y*sens*0.001)
			$Head.rotation.x = clamp($Head.rotation.x, -1.5, 1.6)
			
	

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	#gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	#jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sprint-=10
		if(sprint < 5): sprint = 0
	sprint+=0.08
	if Input.is_action_pressed("sprint"):
		if(sprint>5):
			sprint-=0.18
			SPEED = 13
			if(sprint < 5):
				sprint = 0
		else:
			SPEED = 4
	else:
		SPEED = 4
	sprint = clamp(sprint, 0, 50)
	#allows for WASD movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis.z * input_dir.y + Vector3(0,1,0).cross(transform.basis.z)* input_dir.x).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide() 


	
@rpc("call_local")
func Poke():
	bonk.stop()
	bonk.play("Poke")

@rpc("call_local")
func Sweep():
	bonk.stop()
	bonk.play("Sweep")
