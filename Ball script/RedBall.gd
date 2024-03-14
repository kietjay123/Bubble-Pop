extends Ball
class_name RedBall


func _init():
	super._init()
	ballType = Type.red
	texture = load("res://asset/Red.png")



func doThing() -> void :
	pass
