extends MeshInstance3D

var pos = []

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass



func _on_area_3d_mouse_entered() -> void:
	var material = get_active_material(0).duplicate()
	material.set_feature(BaseMaterial3D.FEATURE_EMISSION, true)
	set_surface_override_material(0, material)

func _on_area_3d_mouse_exited() -> void:
	var material = get_active_material(0).duplicate()
	material.set_feature(BaseMaterial3D.FEATURE_EMISSION, false)
	set_surface_override_material(0, material)
