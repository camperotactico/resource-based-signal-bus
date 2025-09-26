@tool
extends Control

const SignalBusConstants = preload("uid://bio2b7b2kj6mb")

signal variant_type_changed(argument_type_control: Node, variant_type: Variant.Type)
signal variant_type_details_changed(argument_type_control: Node, variant_type_details: String)

@export var variant_type_option_button: OptionButton 
@export var object_details: Control
@export var array_details: Control
@export var dictionary_details: Control

var _current_variant_type: int


var _current_object_class: String
var _current_key_value: String
var _current_array_type: String


func _enter_tree() -> void:
	variant_type_option_button.item_selected.connect(_on_variant_type_option_button_item_selected)
	
func _exit_tree() -> void:
	variant_type_option_button.item_selected.disconnect(_on_variant_type_option_button_item_selected)

func _ready() -> void:
	object_details.hide()
	array_details.hide()
	dictionary_details.hide()
	
	_current_object_class = ""
	_current_key_value = ""
	_current_array_type = ""
	
	variant_type_option_button.clear()
	for i: int in range(1,SignalBusConstants.VARIANT_TYPES.size()):
		variant_type_option_button.add_item(SignalBusConstants.VARIANT_TYPES[i], i)
	variant_type_option_button.select(0)
	variant_type_option_button.item_selected.emit(0)

func _on_variant_type_option_button_item_selected(new_selection_index: int) -> void:
	_current_variant_type = variant_type_option_button.get_item_id(new_selection_index)
	variant_type_changed.emit(self, _current_variant_type)
	
	object_details.hide()
	array_details.hide()
	dictionary_details.hide()
	
	match(_current_variant_type):
		TYPE_OBJECT:
			object_details.show()
			_on_object_class_line_edit_text_changed(_current_object_class)
		TYPE_ARRAY:
			array_details.show()
			_on_array_type_line_edit_text_changed(_current_array_type)
		TYPE_DICTIONARY:
			dictionary_details.show()
			_on_key_value_line_edit_text_changed(_current_key_value)
		_:
			variant_type_details_changed.emit(self,SignalBusConstants.NO_DETAILS)

	

func _on_object_class_line_edit_text_changed(new_text: String) -> void:
	_current_object_class = new_text
	variant_type_details_changed.emit(self,_current_object_class)

func _on_array_type_line_edit_text_changed(new_text: String) -> void:
	_current_array_type = new_text
	variant_type_details_changed.emit(self,_current_array_type)

func _on_key_value_line_edit_text_changed(new_text: String) -> void:
	_current_key_value = new_text
	variant_type_details_changed.emit(self,_current_key_value)
