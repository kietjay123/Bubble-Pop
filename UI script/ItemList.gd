extends ItemList


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_visibility_changed():
	clear()
	var levelNum := LevelCrud.getLevelNum()
	for i in levelNum :
		add_item(str(i))
