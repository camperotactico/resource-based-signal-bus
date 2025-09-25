@tool
extends Node

signal file_system_changed()

var _file_system: EditorFileSystem

func _enter_tree() -> void:
	_file_system = EditorInterface.get_resource_filesystem()
	_file_system.filesystem_changed.connect(_on_filesystem_changed)

func _exit_tree() -> void:
	_file_system.filesystem_changed.disconnect(_on_filesystem_changed)
	_file_system = null

func _on_filesystem_changed() -> void:
	file_system_changed.emit()

func _try_file_system_scan() -> void:
	if not _file_system.is_scanning():
		_file_system.scan()

func _on_custom_signal_bus_script_creator_file_system_scan_requested() -> void:
	_try_file_system_scan()
