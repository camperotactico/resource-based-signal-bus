@tool
extends SignalBus

class_name NodePathSignalBus

signal _signal(arg0: NodePath)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_NODE_PATH]
	
func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: NodePath) -> void:
	_signal.emit(arg0)
