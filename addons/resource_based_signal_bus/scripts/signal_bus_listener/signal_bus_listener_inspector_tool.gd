@tool
extends EditorInspectorPlugin

const NodeMethodPicker = preload("uid://0joveqyr5lim")
const SignalBusListener = preload("uid://da6dhfdepfkku")


func _can_handle(object: Object) -> bool:
	return object is SignalBusListener

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if type == TYPE_STRING_NAME:
		var node_method_picker: NodeMethodPicker = NodeMethodPicker.new()
		node_method_picker.set_signal_bus_listener(object)
		add_property_editor(name,node_method_picker)
		return true
	else:
		return false
