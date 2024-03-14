extends Panel

@onready var levelList  := $ItemList
var selectedLevel : int 
signal onLevelSelect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_pressed():
	visible = false


func _on_load_button_pressed():
	visible = true


func _on_select_pressed():
	if selectedLevel :
		visible = false
		onLevelSelect.emit(selectedLevel)




func _on_item_list_item_selected(index):
	selectedLevel = levelList.get_item_text(index).to_int()





func _on_delete_pressed():
	if selectedLevel :
		visible = false
		LevelCrud.deleteLevel(selectedLevel)
