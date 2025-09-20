@tool
extends SignalBus

class_name BoolSignalBus

signal _signal(arg0: bool)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_BOOL]

func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: bool) -> void:
	_signal.emit(arg0)
