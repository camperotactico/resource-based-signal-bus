@tool
extends Control

signal file_system_scan_requested()
signal initial_save_path_requested()

const SignalBusParametersSerialiser = preload("uid://bkef2bqkvybce")
const SignalBusConstants = preload("uid://bio2b7b2kj6mb")

var _save_filepath: String
var _base_save_dir: String
var _arguments_type_strings: Array[String] 
var _arguments_variant_types: Array[Variant.Type]
var _class_name: String

func _ready() -> void:
	initial_save_path_requested.emit()
	file_system_scan_requested.emit()

func _on_create_script_button_pressed() -> void:
	save_script_to_file()

func save_script_to_file():
	var custom_signal_bus_script_template = FileAccess.open(SignalBusConstants.SIGNAL_BUS_SCRIPT_TEMPLATE_PATH, FileAccess.READ)
	if !custom_signal_bus_script_template:
		_display_error_message(error_string(FileAccess.get_open_error()))
		return
	
	var function_parameters: String = SignalBusParametersSerialiser.get_function_parameters(_arguments_type_strings)
	var variant_type_enum_list: String = SignalBusParametersSerialiser.get_variant_type_enum_list(_arguments_variant_types)
	var callable_arguments: String = SignalBusParametersSerialiser.get_callable_arguments(_arguments_type_strings.size())
	
	var script_contents = custom_signal_bus_script_template.get_as_text()
	script_contents = script_contents % [function_parameters,_class_name,function_parameters,variant_type_enum_list,function_parameters,callable_arguments]
	custom_signal_bus_script_template.close()
	
	if !DirAccess.dir_exists_absolute(_base_save_dir):
		DirAccess.make_dir_recursive_absolute(_base_save_dir)
	
	var file = FileAccess.open(_save_filepath, FileAccess.WRITE)
	if !file:
		_display_error_message(error_string(FileAccess.get_open_error()))
		return
	
	file.store_string(script_contents)
	file.close()
	
	# Refresh the FileSystem
	file_system_scan_requested.emit()
	
func _display_error_message(error_message: String) -> void:
	print(error_message)


func _on_parameters_validator_filepath_changed(new_filepath: String) -> void:
	_save_filepath = new_filepath
	_base_save_dir = new_filepath.get_base_dir()

func _on_parameters_validator_arguments_changed(new_arguments_type_strings: Array[String], new_arguments_variant_types: Array[Variant.Type]) -> void:
	_arguments_type_strings = new_arguments_type_strings
	_arguments_variant_types = new_arguments_variant_types

func _on_parameters_validator_class_name_changed(new_class_name: String) -> void:
	_class_name = new_class_name
