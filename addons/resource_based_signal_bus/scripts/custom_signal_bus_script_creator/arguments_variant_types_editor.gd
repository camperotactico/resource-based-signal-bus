@tool
extends Control

const SignalBusConstants = preload("uid://bio2b7b2kj6mb")

signal arguments_changed(argument_variant_types: Array[Variant.Type], argument_index_to_argument_type_details: Dictionary[int,String])

@export var argument_variant_type_control_packed_scene: PackedScene
@export var controls_parent: Control
@export var number_of_arguments_spin_box: SpinBox

var arguments_variant_types_controls: Array

var argument_type_control_to_index: Dictionary[Node,int]
var arguments_variant_types: Array[Variant.Type]
var argument_index_to_argument_type_details: Dictionary[int,String]

func _enter_tree() -> void:
	number_of_arguments_spin_box.value_changed.connect(_on_number_of_arguments_spin_box_value_changed)

func _exit_tree() -> void:
	number_of_arguments_spin_box.value_changed.disconnect(_on_number_of_arguments_spin_box_value_changed)

func  _ready() -> void:
	arguments_variant_types_controls = []
	argument_type_control_to_index = {}
	argument_index_to_argument_type_details = {}
	number_of_arguments_spin_box.value_changed.emit(number_of_arguments_spin_box.value)

func _on_number_of_arguments_spin_box_value_changed(value: float) -> void:
	var new_number_of_arguments: int = roundi(value)
	var were_controls_deleted: bool = false
	while new_number_of_arguments < arguments_variant_types_controls.size():
		var argument_type_control = arguments_variant_types_controls.pop_back()
		
		argument_type_control.variant_type_changed.disconnect(_on_argument_type_control_variant_type_changed)
		argument_type_control.variant_type_details_changed.disconnect(_on_argument_type_control_variant_type_details_changed)
		
		# Delete control values from argument list
		var argument_index: int = argument_type_control_to_index.get(argument_type_control)
		argument_type_control_to_index.erase(argument_type_control)
		arguments_variant_types.remove_at(argument_index)
		argument_index_to_argument_type_details.erase(argument_index)
		
		argument_type_control.queue_free()
		were_controls_deleted = true
	
	while new_number_of_arguments > arguments_variant_types_controls.size():
		var argument_type_control = argument_variant_type_control_packed_scene.instantiate()
		var argument_index: int = arguments_variant_types_controls.size()
		arguments_variant_types_controls.append(argument_type_control)
		argument_type_control_to_index[argument_type_control] = argument_index
		arguments_variant_types.append(TYPE_NIL)
		
		argument_type_control.variant_type_changed.connect(_on_argument_type_control_variant_type_changed)
		argument_type_control.variant_type_details_changed.connect(_on_argument_type_control_variant_type_details_changed)
		controls_parent.add_child(argument_type_control)
		
	if were_controls_deleted:
		arguments_changed.emit(arguments_variant_types,argument_index_to_argument_type_details)

func _on_argument_type_control_variant_type_changed(argument_type_control: Node, new_variant_type: Variant.Type) -> void:
	var has_changed: bool = false
	var argument_index: int = argument_type_control_to_index[argument_type_control]
	
	if arguments_variant_types[argument_index] != new_variant_type:
		has_changed = true
		arguments_variant_types[argument_index] = new_variant_type
	
	if has_changed:
		arguments_changed.emit(arguments_variant_types,argument_index_to_argument_type_details)

func _on_argument_type_control_variant_type_details_changed(argument_type_control: Node, new_details: String) -> void:
	var has_changed: bool = false
	var argument_index: int = argument_type_control_to_index[argument_type_control]
	if SignalBusConstants.NO_DETAILS == new_details:
		if argument_index_to_argument_type_details.has(argument_index):
			argument_index_to_argument_type_details.erase(argument_index)
			has_changed = true
	else:
		if !argument_index_to_argument_type_details.has(argument_index) or argument_index_to_argument_type_details[argument_index] != new_details:
			argument_index_to_argument_type_details[argument_index] = new_details
			has_changed = true
		
	if has_changed:
		arguments_changed.emit(arguments_variant_types,argument_index_to_argument_type_details)
