@tool
extends Node
const SignalBusConstants = preload("uid://bio2b7b2kj6mb")

# Save Path Validation
const CHARACTERS_NOT_ALLOWED_IN_PATH = ':\\?*"|%<>'
const ABSOLUTE_RES_PATH: String = "res://"
const FILENAME_SUFFIX: String = ".gd"
const CLASS_NAME_SUFFIX: String = "SignalBus"


# Arguments Validation
const ARRAY_OPEN_BRACKET_STRING: String = "Array["
const DICTIONARY_OPEN_BRACKET_STRING: String = "Dictionary["
const CLOSING_BRACKET_STRING: String = "]"
const IS_EMPTY_STRING: String = " "
const CHARACTERS_NOT_ALLOWED_IN_ARGUMENTS: String = "!@#$%^&*()-+=[]{}:;\"'`~,.<>/?\\"


signal script_creation_disabled(is_disabled: bool)

# File Preview TODO: Move these to differt classes: ParameterPreviwer, ErrorDisplayer
const FILENAME_PREVIEW_TEMPLATE: String = "[i]%s[/i]"
const CLASS_NAME_PREVIEW_TEMPLATE: String = "[i]%s[/i]"
const SIGNAL_SIGNATURE_PREVIEW_TEMPLATE: String = "[i]%s[/i]"
const ERROR_TEMPLATE: String = "[color=red]%s[/color]"
signal error_encountered(error_message: String)
signal preview_filename_changed(new_preview_filename: String)
signal preview_class_name_changed(new_preview_class_name: String)
signal preview_signal_signature_changed(new_preview_signal_signature: String)
#

var save_path: String
var _argument_index_to_argument_type_details: Dictionary[int,String]
var _arguments_variant_types: Array[Variant.Type]
var arguments_type_string: Array[String]
var arguments_variant_type_strings: Array[String]
var custom_class_name: String = "MyCustomClass"

func _on_file_system_scanner_file_system_changed() -> void:
	_validate_parameters()

func _on_save_path_editor_save_path_changed(new_save_path: String) -> void:
	save_path = new_save_path
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
	
	var signal_preview: String = "signal _signal("
	for i in arguments_type_string.size():
		signal_preview += " arg%d: %s" % [i,arguments_type_string[i]]
		if (i < arguments_type_string.size()-1):
			signal_preview += ","
	signal_preview += " )"
	preview_signal_signature_changed.emit(SIGNAL_SIGNATURE_PREVIEW_TEMPLATE % signal_preview)
	preview_class_name_changed.emit(CLASS_NAME_PREVIEW_TEMPLATE % custom_class_name)
	preview_filename_changed.emit(FILENAME_PREVIEW_TEMPLATE % get_filepath())
	
func _are_parameters_valid() -> bool:
	# Check save path
	if save_path.is_empty():
		_display_error("Save Path cannot be empty")
		return false
		
	var basename_save_path = save_path.get_basename()
	if save_path != basename_save_path:
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
	custom_class_name = ""
	arguments_type_string = []
	arguments_variant_type_strings = []
	
	for i in _arguments_variant_types.size():
		var variant_type: Variant.Type = _arguments_variant_types[i]
		var argument_type_string: String = SignalBusConstants.VARIANT_TYPES[variant_type].substr(SignalBusConstants.TYPE_UNDERSCORE_LENGTH).to_pascal_case()
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
		
		custom_class_name += class_name_type_string
		arguments_type_string.append(argument_type_string)
		arguments_variant_type_strings.append(SignalBusConstants.VARIANT_TYPES[variant_type])
	
	if IS_EMPTY_STRING in custom_class_name:
		_display_error("An generic Array or Dictionary was delcared using []. Remove the brackets if that is intended. ")
		return false
	
	for character_not_allowed_in_argument in CHARACTERS_NOT_ALLOWED_IN_ARGUMENTS:
		if character_not_allowed_in_argument in custom_class_name:
			_display_error("The Output Class Name cannot contain the character '%s'" % _escape_bb_code(character_not_allowed_in_argument))
			return false
	
	custom_class_name += CLASS_NAME_SUFFIX

	# Check for conflicting files
	if FileAccess.file_exists(get_filepath()):
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
	var key_value_array: PackedStringArray = details.split(",",true,1)
	var key_value: String = ""
	for item in key_value_array:
		if item.begins_with(ARRAY_OPEN_BRACKET_STRING) and details.ends_with(CLOSING_BRACKET_STRING):
			key_value += _parse_array_class_name(extract_details_from(item,ARRAY_OPEN_BRACKET_STRING))
		elif item.begins_with(DICTIONARY_OPEN_BRACKET_STRING) and details.ends_with(CLOSING_BRACKET_STRING):
			key_value += _parse_dictionary_class_name(extract_details_from(item,DICTIONARY_OPEN_BRACKET_STRING))
		else:
			key_value += item.strip_edges().to_pascal_case()
	if key_value.is_empty():
		key_value = IS_EMPTY_STRING
	return "DictionaryOf%s" % key_value

func extract_details_from(string: String, prefix: String) -> String:
	return string.substr(prefix.length(),string.length()-(prefix.length()+CLOSING_BRACKET_STRING.length()))

func get_filepath() -> String:
	return save_path.path_join(custom_class_name.to_snake_case()+FILENAME_SUFFIX)

func _display_error(error_message: String) -> void:
	error_encountered.emit(ERROR_TEMPLATE % error_message)

func _escape_bb_code(string: String) -> String:
	if "[" in string:
		return string.replace("[", "[lb]")
	elif "]" in string:
		return string.replace("]", "[rb]")
	else:
		return string
