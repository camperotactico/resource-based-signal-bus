@tool
extends SignalBus

class_name FloatSignalBus

signal _signal(arg0: float)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_FLOAT]
	
func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: float) -> void:
	_signal.emit(arg0)
