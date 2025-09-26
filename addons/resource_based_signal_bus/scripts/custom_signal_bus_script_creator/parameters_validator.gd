@tool
extends Node

signal script_creation_disabled(is_disabled: bool)
signal error_encountered(error_message: String)
signal filepath_changed(new_filepath: String)
signal class_name_changed(new_class_name: String)
signal arguments_changed(new_arguments_type_strings: Array[String], new_arguments_variant_type: Array[Variant.Type])


const SignalBusConstants = preload("uid://bio2b7b2kj6mb")

# Save Path Validation
const CHARACTERS_NOT_ALLOWED_IN_PATH = ':\\?*"|%<>'
const ABSOLUTE_RES_PATH: String = "res://"
const FILENAME_SUFFIX: String = ".gd"
const CLASS_NAME_SUFFIX: String = "SignalBus"

# Arguments Validation
const TYPE_UNDERSCORE: String =  "TYPE_"
const ARRAY_OPEN_BRACKET_STRING: String = "Array["
const DICTIONARY_OPEN_BRACKET_STRING: String = "Dictionary["
const CLOSING_BRACKET_STRING: String = "]"
const COMMA: String = ","
const IS_EMPTY_STRING: String = "_EMPTY_"
const IS_MISSING_ARGUMENTS_STRING: String = "_MISSING_ARGUMENTS_"
const CHARACTERS_NOT_ALLOWED_IN_ARGUMENTS: String = "!@#$%^&*()-+=[]{}:;\"'`~,.<>/?\\"

# TODO: Move ErrorDisplayer
const ERROR_TEMPLATE: String = "[color=red]%s[/color]"


var _save_path: String
var _argument_index_to_argument_type_details: Dictionary[int,String]
var _arguments_variant_types: Array[Variant.Type]
var _arguments_type_strings: Array[String]
var _custom_class_name: String = "MyCustomClass"

func _on_file_system_scanner_file_system_changed() -> void:
	_validate_parameters()

func _on_save_path_editor_save_path_changed(new_save_path: String) -> void:
	_save_path = new_save_path
	_validate_parameters()

func _on_arguments_variant_types_editor_arguments_changed(new_argument_variant_types: Array[Variant.Type], new_argument_index_to_argument_type_details: Dictionary[int, String]) -> void:
	_arguments_variant_types = new_argument_variant_types
	_argument_index_to_argument_type_details = new_argument_index_to_argument_type_details	
	_validate_parameters()

func _validate_parameters() -> void:
	if _are_parameters_valid():
		script_creation_disabled.emit(false)
	else:
		script_creation_disabled.emit(true)
	
	arguments_changed.emit(_arguments_type_strings,_arguments_variant_types)
	class_name_changed.emit(_custom_class_name)
	filepath_changed.emit(_get_filepath())
	
func _are_parameters_valid() -> bool:
	# Check save path
	if _save_path.is_empty():
		_display_error("Save Path cannot be empty")
		return false
		
	var basename_save_path = _save_path.get_basename()
	if _save_path != basename_save_path:
		_display_error("Save Path should be a directory, not a file.")
		return false

	if !basename_save_path.begins_with(ABSOLUTE_RES_PATH):
		_display_error("Save Path not valid. It should follow the pattern: [i]res://path/to/scripts[/i]")
		return false
	
	var substr_basename_save_path = basename_save_path.substr(ABSOLUTE_RES_PATH.length())
	for character_not_allowed_in_path in CHARACTERS_NOT_ALLOWED_IN_PATH:
		if character_not_allowed_in_path in substr_basename_save_path:
			_display_error("Save Path cannot contain the character '%s'" % character_not_allowed_in_path)
			return false
	
	# Check class name / filename
	_custom_class_name = ""
	_arguments_type_strings = []
	
	for i in _arguments_variant_types.size():
		var variant_type: Variant.Type = _arguments_variant_types[i]
		var argument_type_string: String = SignalBusConstants.VARIANT_TYPES[variant_type].substr(TYPE_UNDERSCORE.length()).to_pascal_case()
		var class_name_type_string: String = argument_type_string
		
		if variant_type == TYPE_OBJECT:
			if  _argument_index_to_argument_type_details.has(i):
				argument_type_string = _argument_index_to_argument_type_details[i]
				class_name_type_string = _argument_index_to_argument_type_details[i].strip_edges()
		if variant_type == TYPE_ARRAY:
			if  _argument_index_to_argument_type_details.has(i):
				argument_type_string += "[%s]" % _argument_index_to_argument_type_details[i].strip_edges()
				class_name_type_string = _parse_array_class_name(_argument_index_to_argument_type_details[i])
		if variant_type == TYPE_DICTIONARY:
			if  _argument_index_to_argument_type_details.has(i):
				argument_type_string += "[%s]" % _argument_index_to_argument_type_details[i].strip_edges()
				class_name_type_string = _parse_dictionary_class_name(_argument_index_to_argument_type_details[i])
		if variant_type == TYPE_INT or variant_type == TYPE_FLOAT or variant_type == TYPE_BOOL:
			argument_type_string = argument_type_string.to_camel_case()
		if variant_type == TYPE_RID or variant_type == TYPE_AABB:
			argument_type_string = argument_type_string.to_upper()
			class_name_type_string = class_name_type_string.to_upper()
		if variant_type == TYPE_TRANSFORM2D or variant_type == TYPE_TRANSFORM3D:
			argument_type_string[argument_type_string.length()-1] = argument_type_string[argument_type_string.length()-1].to_upper()
		
		_custom_class_name += class_name_type_string
		_arguments_type_strings.append(argument_type_string)
	
	if IS_EMPTY_STRING in _custom_class_name:
		_display_error("An generic Array or Dictionary was delcared using []. Remove the brackets if that is intended. ")
		return false
	if IS_MISSING_ARGUMENTS_STRING in _custom_class_name:
		_display_error("A Dictionary is missing an Key or Value.")
		return false
		
	for character_not_allowed_in_argument in CHARACTERS_NOT_ALLOWED_IN_ARGUMENTS:
		if character_not_allowed_in_argument in _custom_class_name:
			_display_error("The Output Class Name cannot contain the character '%s'" % _escape_bb_code(character_not_allowed_in_argument))
			return false
	
	_custom_class_name += CLASS_NAME_SUFFIX

	# Check for conflicting files
	if FileAccess.file_exists(_get_filepath()):
		_display_error("A file with the same name already exists on that path")
		return false
	
	return true

func _parse_array_class_name(details: String ) -> String:
	if details.begins_with(ARRAY_OPEN_BRACKET_STRING) and details.ends_with(CLOSING_BRACKET_STRING):
		return "ArrayOf%s" % _parse_array_class_name(extract_details_from(details,ARRAY_OPEN_BRACKET_STRING))
	elif details.begins_with(DICTIONARY_OPEN_BRACKET_STRING) and details.ends_with(CLOSING_BRACKET_STRING):
		return "ArrayOf%s" % _parse_dictionary_class_name(extract_details_from(details,DICTIONARY_OPEN_BRACKET_STRING))
	
	var type: String = details.strip_edges().to_pascal_case()
	if type.is_empty():
		type = IS_EMPTY_STRING
	return "ArrayOf%s" % type

func _parse_dictionary_class_name(details: String) -> String:
	var input: String = details.strip_edges()
	if input.is_empty():
		return "DictionaryOf%s" % IS_EMPTY_STRING
	if !input.contains(COMMA):
		return "DictionaryOf%s" % IS_MISSING_ARGUMENTS_STRING
		
	var key_value_array: PackedStringArray = input.split(COMMA,true,1)
	var key_value: String = ""
	for item in key_value_array:
		if item.is_empty():
			return "DictionaryOf%s" % IS_MISSING_ARGUMENTS_STRING
		if item.begins_with(ARRAY_OPEN_BRACKET_STRING) and item.ends_with(CLOSING_BRACKET_STRING):
			key_value += _parse_array_class_name(extract_details_from(item,ARRAY_OPEN_BRACKET_STRING))
		elif item.begins_with(DICTIONARY_OPEN_BRACKET_STRING) and item.ends_with(CLOSING_BRACKET_STRING):
			key_value += _parse_dictionary_class_name(extract_details_from(item,DICTIONARY_OPEN_BRACKET_STRING))
		else:
			key_value += item.strip_edges().to_pascal_case()
	return "DictionaryOf%s" % key_value

func extract_details_from(string: String, prefix: String) -> String:
	return string.substr(prefix.length(),string.length()-(prefix.length()+CLOSING_BRACKET_STRING.length()))

func _get_filepath() -> String:
	return _save_path.path_join(_custom_class_name.to_snake_case()+FILENAME_SUFFIX)

func _display_error(error_message: String) -> void:
	error_encountered.emit(ERROR_TEMPLATE % error_message)

func _escape_bb_code(string: String) -> String:
	if "[" in string:
		return string.replace("[", "[lb]")
	elif "]" in string:
		return string.replace("]", "[rb]")
	else:
		return string
