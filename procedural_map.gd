extends Node3D

@export var width : float
@export var depth: float
@export var width_nodes : int
@export var depth_nodes : int
@export var amplitude: float
@export var min_z: float 

@export var height_noise : FastNoiseLite
@export var temperature_noise : FastNoiseLite

# Called when the node enters the scene tree for the first time.

@export var mesh: MeshInstance3D
@export var collision: CollisionShape3D
@export var nav_reg: NavigationRegion3D

var mesh_processed = false
@export var seed: int

signal ready_to_bake
signal generation_finished
var x_scale
var z_scale
	
func get_height(x: float, z:float) -> float:
	var height: float = amplitude*height_noise.get_noise_2d(x,z)
	if(height < min_z): height = min_z;
	return height
	
func perlin_vector3(i: int, j: int) -> Vector3:
	var x = position.x - width/2 + x_scale*i;
	var z = position.z - depth/2 + z_scale*j;
	var height: float = get_height(x,z);
	return Vector3(x-position.x, height, z-position.z);
	
func generate():
	x_scale = width / width_nodes;
	z_scale = depth / depth_nodes;
	height_noise.seed = seed;
	temperature_noise.seed = seed;
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for i in range(width_nodes):
		for j in range(depth_nodes):
			var x = position.x - width/2 + x_scale*i;
			var z = position.z - depth/2 + z_scale*j;
			if(temperature_noise.get_noise_2d(x,z) > 0.1):
				##sand case
				st.set_color(Color.YELLOW);
			elif (temperature_noise.get_noise_2d(x,z) < -0.1):
				##ice case
				st.set_color(Color.SKY_BLUE);
			else:
				##grass case
				st.set_color(Color.GREEN);
			st.add_vertex(perlin_vector3(i,1+j));
			st.add_vertex(perlin_vector3(i,j));
			st.add_vertex(perlin_vector3(1+i,1+j));
			st.add_vertex(perlin_vector3(1+i,1+j));
			st.add_vertex(perlin_vector3(i,j));
			st.add_vertex(perlin_vector3(1+i,j));
	st.generate_normals()
				
	mesh.mesh = st.commit()
	var mat = StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mesh.set_surface_override_material(0, mat)
	#var texture = load("res://biome-export.png");
	#var material = StandardMaterial3D.new();
	#material.albedo_texture = texture;
	#mesh.mesh.surface_set_material(0, material)
	var shape = ConcavePolygonShape3D.new()
	shape.data = mesh.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
	collision.shape = shape
	ready_to_bake.emit();
	


func _on_navigation_region_3d_bake_done() -> void:
	generation_finished.emit()
