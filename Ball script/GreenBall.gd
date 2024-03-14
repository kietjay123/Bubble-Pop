extends Ball
class_name GreenBall

func _init():
	super._init()
	ballType = Type.green
	texture = load("res://asset/Green.png")



func doThing() -> void :
	pass
