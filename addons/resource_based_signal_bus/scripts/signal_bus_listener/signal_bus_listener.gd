@tool
extends Node

signal parameters_changed()

@export_category("Received Signal Bus")
@export var signal_bus: SignalBus:
	get: return _signal_bus
	set(new_signal_bus):
		_signal_bus = new_signal_bus
		parameters_changed.emit()

@export_category("Response")
@export var target: Node:
	get: return _target
	set(new_target):
		_target = new_target
		parameters_changed.emit()
		
@export var ignore_received_signal_arguments: bool:
	get: return _ignore_received_signal_arguments
	set(new_ignore_received_signal_arguments):
		_ignore_received_signal_arguments = new_ignore_received_signal_arguments
		parameters_changed.emit()
		
@export var extra_args: Array[Variant]:
	get: return _extra_args
	set(new_extra_args):
		_extra_args = new_extra_args
		parameters_changed.emit()
@export var callable_string_name: StringName:
	get: return _callable_string_name
	set(new_callable_string_name):
		_callable_string_name = new_callable_string_name

var _signal_bus: SignalBus
var _target: Node
var _ignore_received_signal_arguments: bool
var _extra_args: Array[Variant]
var _callable_string_name: StringName

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		return
	if !signal_bus:
		push_error("No SignalBus assigned to this SignalBusListener.")
		return
	if !_target:
		push_error("The assigned target to this SignalBusListener is null.")
		return
	if callable_string_name.is_empty():
		push_error("The target method is empty.")
		return
	if !_target.has_method(callable_string_name):
		push_error("The target method does not exist in the assigned target.")
		return

	signal_bus.add_connection(_on_signal_bus_received)

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		return
		
	if signal_bus and signal_bus.has_connection(_on_signal_bus_received):
		signal_bus.remove_connection(_on_signal_bus_received)

func _on_signal_bus_received(...args) -> void:
	var all_arguments: Array[Variant] = []
	
	if !ignore_received_signal_arguments:
		all_arguments.append_array(args)
	all_arguments.append_array(extra_args)
	
	if all_arguments.size() > 0:
		_target.callv(callable_string_name,all_arguments)
	else:
		_target.call(callable_string_name)
		

func get_extra_arguments_variant_types() -> Array[Variant.Type]:
	var extra_arguments_variant_types: Array[Variant.Type] = []
	
	for extra_argument in extra_args:
		extra_arguments_variant_types.append(typeof(extra_argument))
	
	return extra_arguments_variant_types
