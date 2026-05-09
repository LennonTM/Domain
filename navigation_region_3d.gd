extends NavigationRegion3D

signal bake_done

func _on_procedural_map_ready_to_bake() -> void:
	bake_navigation_mesh(true);
	bake_done.emit()

	
	
