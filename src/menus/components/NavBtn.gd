extends Button

export var call_function:String
export var function_values:String

func _ready():
	if connect("mouse_entered", self, "_on_mouse_entered") != OK:
		push_error("mouse_entered failed to connect")

func _on_mouse_entered():
	grab_focus()
