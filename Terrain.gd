@tool
extends StaticBody3D
@onready var hitbox = $CollisionShape3D
@export var noise : FastNoiseLite
@export var size : float
@export var mesh_resolution: int
const falloff : float = 0.1
const amplitude : float = 16.0


func _ready():
	generate_mesh_2()
				
func generate_mesh():
	noise.seed = RandomNumberGenerator.new().randi()
	print(noise.seed)
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size, size)
	plane_mesh.subdivide_depth = size*mesh_resolution;
	plane_mesh.subdivide_width = size*mesh_resolution;
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh,0)
	var data = surface_tool.commit_to_arrays()
	var vertices = data[ArrayMesh.ARRAY_VERTEX]
	for i in vertices.size():
		var vertex = vertices[i]
		vertices[i].y = noise.get_noise_2d(vertex.x,vertex.z) * amplitude
		vertices[i].y -= max(abs(vertex.x*falloff), abs(vertex.z*falloff))
	data[ArrayMesh.ARRAY_VERTEX] = vertices
		
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,data)
	surface_tool.create_from(array_mesh,0)
	surface_tool.generate_normals()

	$MeshInstance3D.mesh = surface_tool.commit()
	$CollisionShape3D.shape = array_mesh.create_trimesh_shape()
	#get_parent().navigation_mesh.clear()
	#get_parent().bake_navigation_mesh()
	
func generate_mesh_2():
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)

	# PackedVector**Arrays for mesh construction.
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()

	#######################################
	## Insert code here to generate mesh ##
	#######################################

	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices

	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	$MeshInstance3D.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
