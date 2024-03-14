extends Panel

var selectedLevel : int 

@onready var levelList := $ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_pressed():
	visible = false


func _on_select_pressed():
	if selectedLevel :
		var data : Dictionary = LevelCrud.readLevel(str(selectedLevel))
		var balldata = data["levelBalls"]
		LevelCrud.map = balldata
		LevelCrud.ammo = data["ammo"]
		LevelCrud.cameraReach = data["cameraReach"]
		LevelCrud.levelSize = data["levelSize"]
		SceneManager.changeScene("player")


func _on_play_pressed():
	visible = true


func _on_item_list_item_selected(index):
	selectedLevel = levelList.get_item_text(index).to_int()
