@tool
extends SignalBus

class_name Vector3SignalBus

signal _signal(arg0: Vector3)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_VECTOR3]

func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: Vector3) -> void:
	_signal.emit(arg0)
