extends Spatial

func _ready():
	self.hide()

func _input(event: InputEvent):
	if event.is_action_pressed("action_flashlight"):
		self.set_visible(!self.visible)
		
