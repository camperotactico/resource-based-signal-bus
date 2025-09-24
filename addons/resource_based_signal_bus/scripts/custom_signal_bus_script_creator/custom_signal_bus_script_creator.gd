@tool
extends Control

const ERROR_TEMPLATE: String = "[color=red]%s[/color]"

# Save Path Validation
const CHARACTERS_NOT_ALLOWED_IN_PATH = ':\\?*"|%<>'
const ABSOLUTE_RES_PATH: String = "res://"
const GD_EXTENSION: String = ".gd"

@export var save_path_line_edit: LineEdit


# Arguments
@export var _variant_type_array: Array[Variant.Type]


# Filename
const FILENAME_PREVIEW_TEMPLATE: String = "[i]%s[/i]"

signal preview_filename_changed(new_preview_filename: String)
signal error_encountered(error_message: String)
signal script_creation_disabled(is_disabled: bool)





var _save_path: String = ""
var _class_name: String = "MyCustomClass"

var _file_system: EditorFileSystem

func _enter_tree() -> void:
	_file_system = EditorInterface.get_resource_filesystem()
	_file_system.filesystem_changed.connect(_on_filesystem_changed)
	save_path_line_edit.text_changed.connect(_on_save_path_line_edit_text_changed)
	
	_on_save_path_line_edit_text_changed(save_path_line_edit.text)
	_validate_parameters()

func _exit_tree() -> void:
	save_path_line_edit.text_changed.disconnect(_on_save_path_line_edit_text_changed)
	
	_file_system.filesystem_changed.disconnect(_on_filesystem_changed)
	_file_system = null
	
func _ready() -> void:
	#preview_filename_changed.emit(FILENAME_PREVIEW_TEMPLATE % _class_name.to_snake_case()+GD_EXTENSION)
	pass

func _on_filesystem_changed() -> void:
	_validate_parameters()

func _try_file_system_refresh() -> void:
	if not _file_system.is_scanning():
		_file_system.scan()

func _on_create_script_button_pressed() -> void:
	save_script_to_file()

func save_script_to_file():
	if !DirAccess.dir_exists_absolute(_save_path):
		DirAccess.make_dir_recursive_absolute(_save_path)
	
	var file = FileAccess.open(_get_filepath(), FileAccess.WRITE)
	if !file:
		print(error_string(FileAccess.get_open_error()))
		return
	file.store_line("@tool")
	file.store_line("extends SignalBus")
	file.store_line("")
	file.close()
	
	# Refresh the FileSystem
	_try_file_system_refresh()

func _on_save_path_line_edit_text_changed(new_text: String) -> void:
	_save_path = new_text
	_validate_parameters()

func _validate_parameters() -> void:
	if _are_parameters_valid():
		script_creation_disabled.emit(false)
	else:
		script_creation_disabled.emit(true)
		
func _are_parameters_valid() -> bool:
	# Check save path
	if _save_path.is_empty():
		_display_error("Save Path cannot be empty")
		return false

	var basename_save_path = _save_path.get_basename()
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
	if FileAccess.file_exists(_get_filepath()):
		_display_error("A file with the same name already exists on that path")
		return false
	return true

func _display_error(error_message: String) -> void:
	error_encountered.emit(ERROR_TEMPLATE % error_message)

func _get_filepath() -> String:
	return _save_path.get_basename().path_join(_class_name.to_snake_case()+GD_EXTENSION)
