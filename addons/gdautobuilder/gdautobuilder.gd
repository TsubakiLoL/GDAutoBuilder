@tool
extends EditorPlugin
class_name GDAutoBuilderEditorPlugin

static func get_plugin_path()->String:
	return ((GDAutoBuilderEditorPlugin)as GDScript).resource_path.get_base_dir()

const GD_AUTOBUILDER_PANEL = preload("./scene/gd_autobuilder_panel.tscn")



func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


var panel_cache:Node
func _enter_tree() -> void:
	panel_cache=GD_AUTOBUILDER_PANEL.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL,panel_cache)
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	if is_instance_valid(panel_cache) and panel_cache is Node:
		remove_control_from_docks(panel_cache)
		panel_cache.queue_free()
	pass
