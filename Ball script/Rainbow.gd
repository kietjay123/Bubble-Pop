extends Ball
class_name Rainbow




func _init():
	super._init()
	ballType = Type.rainbow
	texture = load("res://asset/Rainbow.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
