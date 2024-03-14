extends ItemList

@onready var gun = $"../../Gun"

signal addSpecialBall

var ballOffset : int = 3
var selectedBallIdx : int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_item_selected(index):
	selectedBallIdx = index + ballOffset
	addSpecialBall.emit(selectedBallIdx)
	deselect_all()
