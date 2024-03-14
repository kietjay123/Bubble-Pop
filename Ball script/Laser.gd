extends Ball
class_name Laser



func _init():
	super._init()
	ballType = Type.laser
	texture = load("res://asset/Laser.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
