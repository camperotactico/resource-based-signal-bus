@icon("res://addons/resource_based_signal_bus/icons/ResourceBasedSignalBus.svg")
@tool
@abstract class_name SignalBus extends Resource

@abstract func get_arguments_variant_type() -> Array[Variant.Type]
@abstract func add_connection(callable: Callable) -> void
@abstract func remove_connection(callable: Callable) -> void
