@tool
extends EditorPlugin

const SIGNAL_BUS_LISTENER: String = "SignalBusListener"
const SignalBusListenerInspectorTool = preload("uid://bgyam130l63xn")
const SignalBusListener = preload("uid://da6dhfdepfkku")
const ICON = preload("uid://dkfpyxcv5des0")

var signal_bus_listener_inspector_tool: SignalBusListenerInspectorTool

func _enter_tree() -> void:
	signal_bus_listener_inspector_tool = SignalBusListenerInspectorTool.new()
	add_inspector_plugin(signal_bus_listener_inspector_tool)
	add_custom_type(SIGNAL_BUS_LISTENER,"Node",SignalBusListener,ICON)


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _exit_tree() -> void:
	remove_inspector_plugin(signal_bus_listener_inspector_tool)
	remove_custom_type(SIGNAL_BUS_LISTENER)
