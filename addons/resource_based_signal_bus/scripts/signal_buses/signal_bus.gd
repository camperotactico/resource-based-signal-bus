## Base class for [code]SignalBus[/code] resources.
##
## Extend this class to create a custom [code]SignalBus[/code] type.
## [color=yellow] This asset includes a script template to make this process easier. [/color]
## For example, an implementation for a custom [Dictionary]:
## [codeblock]
##@tool
##extends SignalBus
##
##class_name IntToNodePathDictionarySignalBus
##
##signal _signal(arg0: Dictionary[int,NodePath])
##
##func get_arguments_variant_type() -> Array[Variant.Type]:
##	return [TYPE_DICTIONARY]
##
##func add_connection(callable: Callable) -> void:
##	_signal.connect(callable)
##
##func remove_connection(callable: Callable) -> void:
##	_signal.disconnect(callable)
##
##func emit(arg0: Dictionary[int,NodePath]) -> void:
##	_signal.emit(arg0)
## [/codeblock]
@icon("res://addons/resource_based_signal_bus/icons/ResourceBasedSignalBus.svg")
@tool
@abstract class_name SignalBus extends Resource

## Returns a list of the variant types of the arguments of the signal.
## This method is used by the [code]SignalBusListener[/code] class to filter which methods
## of a target [Node] are compatible with this signal.
@abstract func get_arguments_variant_type() -> Array[Variant.Type]
@abstract func add_connection(callable: Callable) -> void
@abstract func remove_connection(callable: Callable) -> void
