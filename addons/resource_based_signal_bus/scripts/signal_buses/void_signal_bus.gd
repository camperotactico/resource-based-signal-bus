@tool
extends SignalBus

class_name VoidSignalBus

signal _signal()

func get_arguments_variant_type() -> Array[Variant.Type]:
	return []

func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit() -> void:
	_signal.emit()
