@tool
extends Control

const SignalBusConstants = preload("uid://bio2b7b2kj6mb")

@export var argument_variant_type_control_packed_scene: PackedScene
@export var controls_parent: Control
@export var number_of_arguments_spin_box: SpinBox

var arguments_variant_types_controls: Array

var argument_type_control_to_index: Dictionary[Node,int]
var arguments_variant_types: Array[Variant.Type]

func _enter_tree() -> void:
	number_of_arguments_spin_box.value_changed.connect(_on_number_of_arguments_spin_box_value_changed)

func _exit_tree() -> void:
	number_of_arguments_spin_box.value_changed.disconnect(_on_number_of_arguments_spin_box_value_changed)

func  _ready() -> void:
	arguments_variant_types_controls = []
	argument_type_control_to_index = {}
	number_of_arguments_spin_box.value_changed.emit(number_of_arguments_spin_box.value)

func _on_number_of_arguments_spin_box_value_changed(value: float) -> void:
	var new_number_of_arguments: int = roundi(value)
	
	while new_number_of_arguments < arguments_variant_types_controls.size():
		var argument_type_control = arguments_variant_types_controls.pop_back()
		argument_type_control_to_index.erase(argument_type_control)
		
		argument_type_control.variant_type_changed.disconnect(_on_argument_type_control_variant_type_changed)
		argument_type_control.variant_type_details_changed.disconnect(_on_argument_type_control_variant_type_details_changed)
		argument_type_control.queue_free()
	
	while new_number_of_arguments > arguments_variant_types_controls.size():
		var argument_type_control = argument_variant_type_control_packed_scene.instantiate()
		argument_type_control.variant_type_changed.connect(_on_argument_type_control_variant_type_changed)
		argument_type_control.variant_type_details_changed.connect(_on_argument_type_control_variant_type_details_changed)

		controls_parent.add_child(argument_type_control)
		argument_type_control_to_index[argument_type_control] = arguments_variant_types_controls.size()
		arguments_variant_types_controls.append(argument_type_control)


func _on_argument_type_control_variant_type_changed(new_variant_type: Variant.Type) -> void:
	print(SignalBusConstants.VARIANT_TYPES[new_variant_type])

func _on_argument_type_control_variant_type_details_changed(new_details: String) -> void:
	print(new_details)
