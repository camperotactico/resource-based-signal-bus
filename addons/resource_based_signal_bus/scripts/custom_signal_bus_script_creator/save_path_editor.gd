@tool
extends Control

signal save_path_changed(new_save_path: String)

@export var save_path_line_edit: LineEdit

func _enter_tree() -> void:
	save_path_line_edit.text_changed.connect(_on_save_path_line_edit_text_changed)

func _exit_tree() -> void:
	save_path_line_edit.text_changed.disconnect(_on_save_path_line_edit_text_changed)

func _on_save_path_line_edit_text_changed(new_text: String) -> void:
	save_path_changed.emit(new_text)

func _on_custom_signal_bus_script_creator_initial_save_path_requested() -> void:
	save_path_changed.emit(save_path_line_edit.text)
