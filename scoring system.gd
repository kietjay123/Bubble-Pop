extends Label


var score : int  = 0
var individualBallScore : int = 50
var streak : int = 0 
var streakPlus : int = 10


@onready var ballManager = $"../../Ball manager"

signal resetStreak


func addScore(balls : Array) -> void :
	score += individualBallScore * balls.size() + streakPlus * streak
	updateScore()


func _ready():
	updateScore()
	ballManager.connect("onBallsDestroyed", Callable(self, "addScore"))




func updateScore() -> void :
	text = "Score : " + str(score)

