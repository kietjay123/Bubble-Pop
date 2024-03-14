extends Ball
class_name Rock



func _init():
	super._init()
	ballType = Type.rock
	texture = load("res://asset/Rock.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
