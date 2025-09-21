@tool
extends SignalBus

class_name StringSignalBus

signal _signal(arg0: String)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_STRING]
	
func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: String) -> void:
	_signal.emit(arg0)
