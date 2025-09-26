extends Node

const SignalBusConstants = preload("uid://bio2b7b2kj6mb")

static func get_function_parameters(new_arguments_type_strings: Array[String]) -> String:
	var func_parameters: String = ""
	for i in new_arguments_type_strings.size():
		func_parameters += "arg%d: %s" % [i,new_arguments_type_strings[i]]
		if i < new_arguments_type_strings.size()-1:
			func_parameters += ", "
	return func_parameters

static func get_callable_arguments(number_of_arguments: int) -> String:
	var func_parameters: String = ""
	for i in number_of_arguments:
		func_parameters += "arg%d" % i
		if i < number_of_arguments-1:
			func_parameters += ", "
	return func_parameters

static func get_variant_type_enum_list(new_arguments_variant_types: Array[Variant.Type]) -> String:
	var enum_list: String = ""
	for i in new_arguments_variant_types.size():
		enum_list += SignalBusConstants.VARIANT_TYPES[new_arguments_variant_types[i]]
		if i < new_arguments_variant_types.size()-1:
			enum_list += ", "
	return enum_list
