@tool
extends SignalBus

class_name ColorSignalBus

signal _signal(arg0: Color)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_COLOR]
	
func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: Color) -> void:
	_signal.emit(arg0)
