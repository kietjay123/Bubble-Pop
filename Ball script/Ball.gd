class_name  Ball
extends Sprite2D

enum Type{red, green, blue, bomb, rocket, rainbow, laser, rock}
var pos : Vector2
var ballType 
var interaceSphere = Area2D.new()
var CS2D = CollisionShape2D.new()
var o = CircleShape2D.new()
var isShooting := false

signal collided

func _init():
	set_scale(Vector2(0.5, 0.5))
	o.radius = 100 - 1
	CS2D.shape = o
	interaceSphere.add_child(CS2D)
	interaceSphere.area_entered.connect(contacted)
	interaceSphere.connect("input_event", Callable(self, "interacted"))
	add_child(interaceSphere)

func interacted(_test1 : Node, input : InputEvent, _test3 : int) -> void :
	if input is InputEventScreenTouch && input.is_pressed():
		doThing()



func doThing() -> void :
	pass



func contacted(hitted : Area2D) -> void :
	if isShooting :
		if hitted.name == "Bottom border" :
			queue_free()
		else :
			collided.emit(self)


func onRemove() -> void :
	pass






