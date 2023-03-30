extends Popup

signal file_name(name)

onready var panel = $PanelContainer
onready var line_edit = $PanelContainer/MarginContainer/VBoxContainer/LineEdit
onready var setup_screen = load("res://src/menus/components/setup_screen.gd").new(panel, self)

func _ready():
	add_child(setup_screen)

# Public: Hides the popup if the cancel button is pressed
func cancel() -> void:
	if self.is_visible():
		self.hide()

# Public: Sets the default text that will be displayed in the text field
func set_default_text(text:String) -> void:
	line_edit.text = text

# Public: Sends the name approved name up to be applied to the save slot.
func accept() -> void:
	emit_signal("file_name", line_edit.text)
