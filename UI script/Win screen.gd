extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_menu_button_pressed():
	get_parent().visible = false
	SceneManager.changeScene("mainMenu")


func _on_retry_button_pressed():
	get_parent().visible = false
	SceneManager.changeScene("player")
