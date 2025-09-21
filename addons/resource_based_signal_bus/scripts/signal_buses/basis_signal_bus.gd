@tool
extends SignalBus

class_name BasisSignalBus

signal _signal(arg0: Basis)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_BASIS]

func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: Basis) -> void:
	_signal.emit(arg0)
