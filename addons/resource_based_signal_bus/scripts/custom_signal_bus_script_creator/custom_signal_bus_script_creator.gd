@tool
extends Control

signal file_system_scan_requested()
signal initial_save_path_requested()

const ParametersValidator = preload("uid://u3ufpv7r5puc")



@export var parameters_validator: ParametersValidator


func _ready() -> void:
	initial_save_path_requested.emit()
	file_system_scan_requested.emit()

func _on_create_script_button_pressed() -> void:
	save_script_to_file()

func save_script_to_file():
	if !DirAccess.dir_exists_absolute(parameters_validator.save_path):
		DirAccess.make_dir_recursive_absolute(parameters_validator.save_path)
	
	var file = FileAccess.open(parameters_validator.get_filepath(), FileAccess.WRITE)
	if !file:
		print(error_string(FileAccess.get_open_error()))
		return
	file.store_line("@tool")
	file.store_line("extends SignalBus")
	file.store_line("")
	file.close()
	
	# Refresh the FileSystem
	file_system_scan_requested.emit()
