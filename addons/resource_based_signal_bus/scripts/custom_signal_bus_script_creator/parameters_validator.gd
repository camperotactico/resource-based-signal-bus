@tool
extends Node


# Save Path Validation
const CHARACTERS_NOT_ALLOWED_IN_PATH = ':\\?*"|%<>'
const ABSOLUTE_RES_PATH: String = "res://"
const SUFIX_DOT_GD: String = "_signal_bus.gd"


signal script_creation_disabled(is_disabled: bool)

# File Preview TODO: Move these to differt classes: ParameterPreviwer, ErrorDisplayer
const FILENAME_PREVIEW_TEMPLATE: String = "[i]%s[/i]"
const ERROR_TEMPLATE: String = "[color=red]%s[/color]"
signal error_encountered(error_message: String)
signal preview_filename_changed(new_preview_filename: String)
#

var save_path: String
var custom_class_name: String = "MyCustomClass"

func _on_file_system_scanner_file_system_changed() -> void:
	_validate_parameters()

func _on_save_path_editor_save_path_changed(new_save_path: String) -> void:
	save_path = new_save_path
	_validate_parameters()


func _validate_parameters() -> void:
	if _are_parameters_valid():
		script_creation_disabled.emit(false)
		preview_filename_changed.emit(FILENAME_PREVIEW_TEMPLATE % get_filepath())
	else:
		script_creation_disabled.emit(true)
		preview_filename_changed.emit(FILENAME_PREVIEW_TEMPLATE % "Invalid path!")
		
func _are_parameters_valid() -> bool:
	# Check save path
	if save_path.is_empty():
		_display_error("Save Path cannot be empty")
		return false

	var basename_save_path = save_path.get_basename()
	if basename_save_path.is_empty() or !basename_save_path.begins_with(ABSOLUTE_RES_PATH):
		_display_error("Save Path not valid. It should follow the pattern: [i]res://path/to/scripts[/i]")
		return false
	
	var substr_basename_save_path = basename_save_path.substr(ABSOLUTE_RES_PATH.length())
	for character_not_allowed_in_path in CHARACTERS_NOT_ALLOWED_IN_PATH:
		if character_not_allowed_in_path in substr_basename_save_path:
			_display_error("Save Path cannot contain the character '%s'" % character_not_allowed_in_path)
			return false
	
	# Check class name / filename
	
	# Check for conflicting files
	if FileAccess.file_exists(get_filepath()):
		_display_error("A file with the same name already exists on that path")
		return false
	return true

func get_filepath() -> String:
	return save_path.get_basename().path_join(custom_class_name.to_snake_case()+SUFIX_DOT_GD)

func _display_error(error_message: String) -> void:
	error_encountered.emit(ERROR_TEMPLATE % error_message)
