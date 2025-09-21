@tool
extends SignalBus

class_name Transform2DSignalBus

signal _signal(arg0: Transform2D)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_TRANSFORM2D]

func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: Transform2D) -> void:
	_signal.emit(arg0)
