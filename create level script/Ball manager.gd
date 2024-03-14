extends Node



@onready var ballRowUI = $"../Camera2D/UI/Ball grid/LineEdit"
@onready var levelNumInput = $"../Camera2D/UI/Level control/LineEdit"
@onready var camReachUI = $"../Camera2D/UI/Camera reach control/LineEdit"


var ballRowNum : int 
var ballColumm : int
var gridSize : int
var ballMap : Array = []
var cameraY : int = 0
var ballTypeArray : Array = ["red", "green", "blue", "eraser"]
var selectedBallType : int 
var ammo : Array = []
var cameraReach : int 
var levelNum : int 

const ballScript= preload("res://Ball.gd")


var red = load("res://asset/Red.png")
var green = load("res://asset/Green.png")
var blue = load("res://asset/Blue.png")
var bomb = load("res://asset/Bomb.png")


signal on_autoFill_trigger


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_Apply_pressed()
	_on_camReach_button_pressed()
	



func _on_Apply_pressed():
	for i in ballMap :
		for ii in i :
			if ii :
				ii.queue_free()
	ballMap.clear()
	ballRowNum = ballRowUI.text.to_int()
	gridSize  = floor(ProjectSettings.get_setting("display/window/size/viewport_width") / ballRowNum)
	ballColumm = ProjectSettings.get_setting("display/window/size/viewport_height") / gridSize
	for i in ballMap :
		i.resize(ballRowNum)



func _on_new_Button_pressed():
	pass # Replace with function body.


func _on_load_Button_pressed():
	pass # Replace with function body.



func _on_save_Button_pressed():
	pass # Replace with function body.



#row and columm inverted
func getTouchPos(touchPos : Vector2 ) -> Vector2 :
	var columm : int = floor(touchPos.y / gridSize)
	var row  : int
	if columm % 2 == 1 :
		row = clamp(abs(((touchPos.x - (gridSize / 2)) / gridSize)), 0, ballRowNum - 2)
	else : # including 0
		row = clamp(floor(touchPos.x / gridSize), 0, ballRowNum - 1)
	return Vector2(row, columm)
	

func _unhandled_input(event):
	if event is InputEventKey and event.is_pressed() :
		if event.keycode == KEY_1 :
			for i in ballMap :
				#print(i)
				pass



#make sure there is space in the array to avoid stack overflow
func addBall(pos : Vector2i, pBallType : int = -1) -> void :
	var ballType : String
	if pBallType == -1 :
		ballType = ballTypeArray[selectedBallType]
	else :
		ballType = ballTypeArray[pBallType]
	if pos.y  + 1 > ballMap.size() :
		ballMap.resize(pos.y + 1)
		for i in ballMap.size() :
			if !ballMap[i] :
				ballMap[i] = []
				ballMap[i].resize(ballRowNum)
	if ballMap[pos.y][pos.x] != null:
		if ballMap[pos.y][pos.x].name.begins_with(ballType) :
			return
	else :
		var ball := createBall(ballType , pos)
		add_child(ball)
		ballMap[pos.y][pos.x] = ball
		ball.position = getPosition(pos)
		ball.set_scale(Vector2(gridSize, gridSize) / (ball.texture.get_size()))




func clear() -> void :
	#for i in ballMap :
		#for ii in i :
			#if ii :
				#ii.queue_free()
	ballMap = []



func createBall(type : String, nameIdx : Vector2) -> Sprite2D:
	
	var result : Sprite2D = Sprite2D.new()
	result.name = type + " " + str(nameIdx)
	match type :
		"red":
			result.texture = red
		"green" :
			result.texture = green
		"blue" :
			result.texture = blue
		"bomb" :
			result.texture = bomb
	return result



func deleteBall(pos : Vector2) -> void :
	if pos.y < ballMap.size() :
		if ballMap[pos.y][pos.x] :
			ballMap[pos.y][pos.x].queue_free()
			ballMap[pos.y][pos.x] = null



func getPosition(pos : Vector2) -> Vector2 :
	var result : Vector2 = Vector2.ZERO
	result  = pos * gridSize + Vector2(gridSize/2 , gridSize/2)
	if int(pos.y) % 2 != 0 :
		result += Vector2(gridSize / 2 , 0)
	return result


func exportMap() -> Array :
	var result := ballMap.duplicate(true)
	for i in result.size() :
		for ii in result[i].size() :
			var ball = result[i][ii]
			if ball :
				if ball.name.begins_with("red") :
					result[i][ii] = [ballScript.Type.red]
				elif ball.name.begins_with("green") :
					result[i][ii] = [ballScript.Type.green]
				elif ball.name.begins_with("blue") :
					result[i][ii] = [ballScript.Type.blue]
				elif ball.name.begins_with("bomb") :
					result[i][ii] = [ballScript.Type.bomb]
	return result



func _on_Test_button_pressed():
	LevelCrud.map = exportMap()
	LevelCrud.ammo = createRanAmmo()
	LevelCrud.cameraReach = cameraReach
	LevelCrud.levelSize = ballRowNum
	SceneManager.changeScene("player")



func _on_Ball_option_item_selected(index):
	selectedBallType = index
	


func _on_save_button_pressed():
	if LevelReadyToSave() :
		LevelCrud.addLevel(levelNum, exportMap(), ballRowNum, ammo, cameraReach)
	else :
		emit_signal("on_autoFill_trigger")



func LevelReadyToSave() -> bool :
	levelNum = levelNumInput.text.to_int()
	cameraReach = camReachUI.text.to_int()
	if levelNum == 0 :
		return false
	if ammo.is_empty() :
		return false
	if cameraReach == 0 :
		return false
	if exportMap().is_empty() :
		return false 
	return true



func _on_camReach_button_pressed() -> void :
	cameraReach = camReachUI.text.to_int()


func _on_autofill_button_pressed() -> void :
	if levelNum == 0 :
		levelNumInput.text = str(LevelCrud.returnBiggestLevelNum() + 1)
	if ammo.is_empty() :
		ammo = createRanAmmo()
	if cameraReach == 0 :
		camReachUI.text = "8"



func createRanAmmo() -> Array[int] :
	var result : Array[int] = []
	for i in 30 :
		result.append(randi_range(0,2))
	return result


func import(data : Dictionary) -> void :
	#inx : int, levelBalls : Array, levelSize : int, PAmmo : Array[int], cameraReach : int
	ballRowUI.text = str(data["levelSize"])
	_on_Apply_pressed()
	var rawBallMap : Array = data["levelBalls"]
	ammo = data["ammo"]
	cameraReach = data["cameraReach"]
	camReachUI.text = str(cameraReach)
	clear()
	for i in rawBallMap.size() : 
		for ii in rawBallMap[i].size() :
			if rawBallMap[i][ii] :
				addBall(Vector2i(ii, i), rawBallMap[i][ii][0])


func _on_level_select_on_level_select(selectedLevel : int):
	levelNumInput.text = str(selectedLevel)
	import(LevelCrud.readLevel(str(selectedLevel)))
