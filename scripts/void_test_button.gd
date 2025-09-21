extends Button

@export var void_signal_bus: VoidSignalBus

func _enter_tree() -> void:
	pressed.connect(_on_pressed)

func _exit_tree() -> void:
	pressed.disconnect(_on_pressed)

func _on_pressed() -> void:
	if !void_signal_bus:
		push_error("No signal bus assigned to the no arguments test button!")
		return
	void_signal_bus.emit()
