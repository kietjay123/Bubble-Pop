extends Node2D

@onready var loseScreen = $"Camera2D/Lose screen"
@onready var winScreen = $"Camera2D/Win screen"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ball_manager_win():
	winScreen.visible = true


func _on_gun_lose():
	loseScreen.visible = true
