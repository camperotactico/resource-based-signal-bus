@tool
extends SignalBus

class_name ResourceSignalBus

signal _signal(arg0: Resource)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_OBJECT]

func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: Resource) -> void:
	_signal.emit(arg0)
