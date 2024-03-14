extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ball_manager_on_auto_fill_trigger():
	visible = true
	await $"Autofill button".pressed
	visible = false


func _on_return_button_pressed():
	visible = false
