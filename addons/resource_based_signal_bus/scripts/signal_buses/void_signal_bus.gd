@tool
extends SignalBus

## A resource type that extends [code]SignalBus[/code].
## It wraps the following signal:
## [codeblock]
## signal _signal()
## [/codeblock]
class_name VoidSignalBus

signal _signal()

func get_arguments_variant_type() -> Array[Variant.Type]:
	return []

func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

func emit() -> void:
	_signal.emit()
