extends Ball
class_name Bomb


func _init():
	super._init()
	ballType = Type.bomb
	texture = load("res://asset/Bomb.png")



func doThing() -> void :
	print("bomb")
