@tool
extends SignalBus

class_name Vector3iSignalBus

signal _signal(arg0: Vector3i)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_VECTOR3I]

func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: Vector3i) -> void:
	_signal.emit(arg0)
