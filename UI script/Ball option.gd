extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_item("red", 0)
	add_item("green", 1)
	add_item("blue", 2)
	add_item("eraser", 3)
	select(0)
	emit_signal("item_selected" , selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_camera_Down_button_down():
	pass # Replace with function body.
