@tool
extends Control

const VARIANT_TYPES: Array[String] = ["TYPE_NIL", "TYPE_BOOL", "TYPE_INT", "TYPE_FLOAT", "TYPE_STRING", "TYPE_VECTOR2", "TYPE_VECTOR2I", "TYPE_RECT2", "TYPE_RECT2I", "TYPE_VECTOR3", "TYPE_VECTOR3I", "TYPE_TRANSFORM2D", "TYPE_VECTOR4", "TYPE_VECTOR4I", "TYPE_PLANE", "TYPE_QUATERNION", "TYPE_AABB", "TYPE_BASIS", "TYPE_TRANSFORM3D", "TYPE_PROJECTION", "TYPE_COLOR", "TYPE_STRING_NAME", "TYPE_NODE_PATH", "TYPE_RID", "TYPE_OBJECT", "TYPE_CALLABLE", "TYPE_SIGNAL", "TYPE_DICTIONARY", "TYPE_ARRAY", "TYPE_PACKED_BYTE_ARRAY", "TYPE_PACKED_INT32_ARRAY", "TYPE_PACKED_INT64_ARRAY", "TYPE_PACKED_FLOAT32_ARRAY", "TYPE_PACKED_FLOAT64_ARRAY", "TYPE_PACKED_STRING_ARRAY", "TYPE_PACKED_VECTOR2_ARRAY", "TYPE_PACKED_VECTOR3_ARRAY", "TYPE_PACKED_COLOR_ARRAY", "TYPE_PACKED_VECTOR4_ARRAY"]



@export var variant_type_option_button: OptionButton 
@export var object_details: Control
@export var array_details: Control
@export var dictionary_details: Control

var _current_variant_type: int


func _enter_tree() -> void:
	variant_type_option_button.item_selected.connect(_on_variant_type_option_button_item_selected)
	
func _exit_tree() -> void:
	variant_type_option_button.item_selected.disconnect(_on_variant_type_option_button_item_selected)


func _ready() -> void:
	_current_variant_type = 1
	object_details.hide()
	array_details.hide()
	dictionary_details.hide()
	
	for i: int in range(1,VARIANT_TYPES.size()):
		variant_type_option_button.add_item(VARIANT_TYPES[i], i)


func _on_variant_type_option_button_item_selected(new_selection_index: int) -> void:
	_current_variant_type = variant_type_option_button.get_item_id(new_selection_index)
	
	object_details.hide()
	array_details.hide()
	dictionary_details.hide()
	
	match(_current_variant_type):
		TYPE_OBJECT:
			object_details.show()
		TYPE_ARRAY:
			array_details.show()
		TYPE_DICTIONARY:
			dictionary_details.show()
		_:
			pass
