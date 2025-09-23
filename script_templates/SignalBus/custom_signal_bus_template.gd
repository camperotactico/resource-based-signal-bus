# meta-name: Custom Signal Bus
# meta-description: Template to create a new SignalBus type.
# meta-default: true
# meta-space-indent: 4
@tool
extends _BASE_

class_name _CLASS_

# Replace ARGUMENT_TYPE:
# e.g: _signal(arg0: float, arg1: Array)
signal _signal(arg0: ARGUMENT_TYPE, arg1: ARGUMENT_TYPE)

# Replace ARGUMENT_VARIANT_TYPE:
# e.g: return [TYPE_FLOAT,TYPE_ARRAY]
func get_arguments_variant_type() -> Array[Variant.Type]:
	return [ARGUMENT_VARIANT_TYPE,ARGUMENT_VARIANT_TYPE]

func add_connection(callable: Callable) -> void:
	_signal.connect(callable)

func remove_connection(callable: Callable) -> void:
	_signal.disconnect(callable)

# Replace ARGUMENT_TYPE:
# e.g: emit(arg0: float, arg1: Array)
#		_signal(arg0, arg1)
func emit(arg0: ARGUMENT_TYPE, arg1: ARGUMENT_TYPE) -> void:
	_signal.emit(arg0,arg1)
