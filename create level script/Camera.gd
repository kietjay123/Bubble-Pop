extends Camera2D


@onready var ballManager = $"../Ball manager"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Up_button_down():
	position += Vector2(0, -50)


func _on_Down_button_down():
	position += Vector2(0, 50)




func _unhandled_input(event):
	if (event is InputEventScreenTouch and event.is_pressed()) || event is InputEventScreenDrag :
		if ballManager.selectedBallType == 3 :
			ballManager.deleteBall(ballManager.getTouchPos(to_global(event.position)))
		else :
			ballManager.addBall(ballManager.getTouchPos(to_global(event.position)))


