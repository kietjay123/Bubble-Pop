extends Camera2D

var seeableBubbleRow := 8

@onready var ballManager = $"../Ball manager"
@onready var leftBorder := $"Left border"
@onready var rightBorder := $"Right border"

@export var camSpeed : float = 50

func _ready():
	ballManager.connect("moveCam", Callable(self, "onMoveCam"))
	leftBorder.position += Vector2( ballManager.gridSize / 2, 0 )
	rightBorder.position += Vector2( -ballManager.gridSize / 2, 0 )
	seeableBubbleRow = LevelCrud.cameraReach
	ballManager.moveCamera()



func transitionUpdatePos() -> void :
	pass


func snap(y : int) -> void :
	position = Vector2(position.x, y * ballManager.gridSize)


func onMoveCam( y : int) -> void :
	var staringRow = y  + 1 - seeableBubbleRow
	staringRow = max(staringRow, 0)
	var tween = create_tween()
	var from = position.y
	var to = staringRow * ballManager.gridSize
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position", Vector2(position.x, to), abs((to - from) / camSpeed))


