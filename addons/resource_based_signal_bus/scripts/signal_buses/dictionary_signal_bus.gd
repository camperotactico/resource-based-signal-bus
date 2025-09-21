@tool
extends SignalBus

class_name DictionarySignalBus

signal _signal(arg0: Dictionary)

func get_arguments_variant_type() -> Array[Variant.Type]:
	return [TYPE_DICTIONARY]

func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit(arg0: Dictionary) -> void:
	_signal.emit(arg0)
