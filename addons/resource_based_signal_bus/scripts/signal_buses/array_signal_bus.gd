@tool
extends SignalBus

class_name ArraySignalBus

signal _signal(arg0: Array)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_ARRAY]

func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: Array) -> void:
	_signal.emit(arg0)
