@tool
extends Control

const SignalBusParametersSerialiser = preload("uid://bkef2bqkvybce")


const FILEPATH_PREVIEW_TEMPLATE: String = "[i]%s[/i]"
const CLASS_NAME_PREVIEW_TEMPLATE: String = "[i]%s[/i]"
const SIGNAL_SIGNATURE_PREVIEW_TEMPLATE: String = "[i]signal _signal(%s)[/i]"

@export var signal_signature_preview_rich_text_label: RichTextLabel
@export var class_name_preview_rich_text_label: RichTextLabel
@export var filepath_preview_rich_text_label: RichTextLabel


func _on_parameters_validator_class_name_changed(new_class_name: String) -> void:
	class_name_preview_rich_text_label.text = CLASS_NAME_PREVIEW_TEMPLATE % new_class_name

func _on_parameters_validator_filepath_changed(new_filename: String) -> void:
	filepath_preview_rich_text_label.text = FILEPATH_PREVIEW_TEMPLATE % new_filename

func _on_parameters_validator_arguments_changed(new_arguments_type_strings: Array[String], _new_arguments_variant_types: Array[Variant.Type]) -> void:
	var fucntion_parameters: String = SignalBusParametersSerialiser.get_function_parameters(new_arguments_type_strings)
	signal_signature_preview_rich_text_label.text = SIGNAL_SIGNATURE_PREVIEW_TEMPLATE % fucntion_parameters
