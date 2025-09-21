@tool
extends SignalBus

class_name StringNameSignalBus

signal _signal(arg0: StringName)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_STRING_NAME]
	
func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: StringName) -> void:
	_signal.emit(arg0)
