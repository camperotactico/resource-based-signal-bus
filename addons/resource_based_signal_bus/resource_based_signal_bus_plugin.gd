@tool
extends EditorPlugin

# Signal Bus Listener
const SIGNAL_BUS_LISTENER: String = "SignalBusListener"
const SignalBusListenerInspectorTool = preload("uid://bgyam130l63xn")
const SignalBusListener = preload("uid://da6dhfdepfkku")
const SIGNAL_BUS_LISTENER_ICON = preload("uid://dkfpyxcv5des0")
var signal_bus_listener_inspector_tool: SignalBusListenerInspectorTool

# Custom Signal Bus Creator
const CustomSignalBusScriptCreator = preload("uid://of5af3ng1gf0")
var custom_signal_bus_script_creator: Control

func _enter_tree() -> void:
	# Signal Bus Listener
	signal_bus_listener_inspector_tool = SignalBusListenerInspectorTool.new()
	add_inspector_plugin(signal_bus_listener_inspector_tool)
	add_custom_type(SIGNAL_BUS_LISTENER,"Node",SignalBusListener,SIGNAL_BUS_LISTENER_ICON)
	
	# Custom Signal Bus Creator
	custom_signal_bus_script_creator = CustomSignalBusScriptCreator.instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_UR,custom_signal_bus_script_creator)


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _exit_tree() -> void:
	# Signal Bus Listener
	remove_inspector_plugin(signal_bus_listener_inspector_tool)
	remove_custom_type(SIGNAL_BUS_LISTENER)
	
	# Custom Signal Bus Creator
	remove_control_from_docks(custom_signal_bus_script_creator)
	custom_signal_bus_script_creator.free()
	
