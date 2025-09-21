@tool
extends SignalBus

class_name Transform3DSignalBus

signal _signal(arg0: Transform3D)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_TRANSFORM3D]

func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: Transform3D) -> void:
	_signal.emit(arg0)
