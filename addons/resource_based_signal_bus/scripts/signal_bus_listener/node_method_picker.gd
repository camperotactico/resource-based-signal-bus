@tool
extends EditorProperty

const SignalBusListener = preload("uid://da6dhfdepfkku")
const NO_SELECTION_ID: int = -1
const NO_SELECTION_STRING_NAME: StringName = ""

var property_control = OptionButton.new()
var current_value: StringName
var updating = false

var signal_bus_listener: SignalBusListener
var id_to_method_string_name: Dictionary[int,StringName]
var method_string_name_to_id: Dictionary[StringName,int]

func _init():
	add_child(property_control)
	add_focusable(property_control)
		
	property_control.item_selected.connect(_on_item_selected)
	property_control.toggled.connect(_on_option_button_toggled)

func set_signal_bus_listener(new_signal_bus_listener: SignalBusListener) -> void:
	signal_bus_listener = new_signal_bus_listener
	signal_bus_listener.parameters_changed.connect(_on_signal_bus_listener_parameters_changed)
	refresh_option_button_options()
	

func _on_option_button_toggled(toggled: bool) -> void:
	if toggled:
		refresh_option_button_options()

func _update_property() -> void:
	var new_value = get_edited_object()[get_edited_property()]
	if new_value == current_value:
		return
	
	updating = true
	current_value = new_value
	refresh_option_button_options()
	updating = false

func _on_item_selected(new_time_id: int) -> void:
	if updating:
		return
	
	if new_time_id != NO_SELECTION_ID:
		current_value = id_to_method_string_name[new_time_id]
	else:
		current_value = NO_SELECTION_STRING_NAME
	emit_changed(get_edited_property(),current_value)

func _on_signal_bus_listener_parameters_changed():
	refresh_option_button_options()

func refresh_option_button_options() -> void:
	id_to_method_string_name.clear()
	method_string_name_to_id.clear()
	property_control.clear()
	
	if !signal_bus_listener.signal_bus or !signal_bus_listener.target:
		property_control.selected = NO_SELECTION_ID
		current_value = NO_SELECTION_STRING_NAME
		return

	var arguments: Array[Variant.Type] = []
	if !signal_bus_listener.ignore_received_signal_arguments:
		arguments.append_array(signal_bus_listener.signal_bus.get_arguments_variant_type())
	arguments.append_array(signal_bus_listener.get_extra_arguments_variant_types())
	
	var i = 0;
	for method: Dictionary in signal_bus_listener.target.get_method_list():
		if method.name.begins_with("_"):
			continue
		if method.return.type != TYPE_NIL:
			continue
		if !_is_method_matching_arguments(method,arguments):
			continue
		id_to_method_string_name[i] = method.name
		method_string_name_to_id[method.name] = i
		property_control.add_item(method.name, i)
		i += 1
	
	if !method_string_name_to_id.has(current_value):
		property_control.selected = NO_SELECTION_ID
		current_value = NO_SELECTION_STRING_NAME
		return
		
	property_control.selected = method_string_name_to_id[current_value]

func _is_method_matching_arguments(method: Dictionary, arguments: Array[Variant.Type]) -> bool:
	if method.args.size() != arguments.size():
		return false
	for i in range(arguments.size()):
		if arguments[i] != method.args[i].type:
			return false
	return true
