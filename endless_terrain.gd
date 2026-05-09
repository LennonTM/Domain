extends Node3D
@export var viewer_name: String
const chunk_size: int = 16;
const view_radius: int = 160;
var chunk_dict = {}
var chunks_visible: int

var requested_chunks : Array
var to_add
var processing = false
var seed;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chunks_visible = round(float(view_radius)/float(chunk_size))

var counter = 0;

var enabled_chunks

signal generation_initiliased

func get_height(x: float, z: float):
	var index = Vector2(x/chunk_size, z/chunk_size);
	return chunk_dict[index].get_height(x,z);
	
func generate(seed: int):
	self.seed = seed
	var viewer_chunk_x = 0;
	var viewer_chunk_y = 0;
	for x_offset in range(-chunks_visible, chunks_visible+1):
		for y_offset in range(-chunks_visible, chunks_visible+1):
			var current_chunk: Vector2 = Vector2(x_offset + viewer_chunk_x, y_offset + viewer_chunk_y)
			if !chunk_dict.has(current_chunk):
				var chunk = load("res://procedural_map.tscn").instantiate();
				chunk.seed = seed;
				chunk.width = chunk_size
				chunk.depth = chunk_size
				chunk.position = Vector3(current_chunk.x*chunk_size, 0, current_chunk.y*chunk_size);
				chunk.generate();
				chunk_dict[current_chunk] = chunk;
				add_child(chunk);
	generation_initiliased.emit();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !viewer_name: return
	var viewer = get_parent().get_node(viewer_name);
	if !viewer: return
	var viewer_chunk_x: int = round(viewer.position.x / float(chunk_size));
	var viewer_chunk_y: int = round(viewer.position.z / float(chunk_size));

	requested_chunks = [];
	enabled_chunks = []
	for x_offset in range(-chunks_visible, chunks_visible+1):
		for y_offset in range(-chunks_visible, chunks_visible+1):
			var current_chunk: Vector2 = Vector2(x_offset + viewer_chunk_x, y_offset + viewer_chunk_y)
			enabled_chunks.append(current_chunk);
			if !chunk_dict.has(current_chunk):
				requested_chunks.append(current_chunk);
	if !processing && !requested_chunks.is_empty():
		for chunk_key in chunk_dict.keys():
			if !enabled_chunks.has(chunk_key):
				chunk_dict[chunk_key].queue_free()
				chunk_dict.erase(chunk_key)
		processing = true;
		var thread = Thread.new()
		thread.start(generate_chunks.bind(requested_chunks))
	
func generate_chunks(chunks_to_generate: Array):
	var to_add = []
	for current_chunk in chunks_to_generate:
		var chunk = load("res://procedural_map.tscn").instantiate();
		chunk.seed = seed;
		chunk.width = chunk_size
		chunk.depth = chunk_size
		chunk.position = Vector3(current_chunk.x*chunk_size, 0, current_chunk.y*chunk_size);
		chunk.generate();
		to_add.append({'coord': current_chunk, 'chunk': chunk})
		chunk_dict[current_chunk] = chunk;
	
	call_deferred("_on_chunks_generated", to_add)
	
	
func _on_chunks_generated(chunks_to_add: Array):
	for chunk_to_add in chunks_to_add:
		var chunk = chunk_to_add['chunk']
		var current_chunk = chunk_to_add['coord']
		chunk_dict[current_chunk] = chunk
		add_child(chunk);
	processing = false;
		
@rpc("call_local", "authority")
func assign_viewer(viewer_name: String):
	self.viewer_name = viewer_name
