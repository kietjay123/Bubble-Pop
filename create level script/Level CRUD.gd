class_name LevelCRUD

extends Node


var path := "res://save.json"



var level_data := {
}


var map : Array = []
var ammo : Array = []
var cameraReach : int  
var levelSize : int


func _ready():
	level_data = loadJSON()



func loadJSON() :
	if FileAccess.file_exists(path) :
		
		var dataFile = FileAccess.open(path, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary :
			return parsedResult
		else :
			push_warning("unexpected data type")
		
	else :
		push_warning("file does not exist")






func returnBiggestLevelNum() -> int :
	var levelNumber = level_data.keys().map(func(input : String) : return input.to_int()).max()
	if levelNumber :
		return levelNumber
	else :
		return 0


func addLevel(inx : int, levelBalls : Array, PLevelSize : int, PAmmo : Array[int], cameraReach : int ) -> void :
	var levelData := {
			"levelBalls" : levelBalls,
			"levelSize"  : PLevelSize,
			"ammo" : PAmmo,
			"cameraReach"  : cameraReach
		}
	level_data[str(inx)] = levelData
	saveJSON()


func saveJSON() -> void :
	if FileAccess.file_exists(path) :
		
		var dataFile = FileAccess.open(path, FileAccess.WRITE)
		var toStore := JSON.stringify(level_data)
		dataFile.store_string(toStore)
		dataFile.close()
		
	else :
		push_warning("file does not exist")


func wipe() -> void :
	map  = []
	ammo  = []
	cameraReach = 0
	levelSize = 0


func readLevel(levelIdx : String) -> Dictionary  :
	return level_data[levelIdx]


func deleteLevel(levelIdx : int) -> void :
	var error = level_data.erase(str(levelIdx))
	saveJSON()


func getLevelNum() -> Array :
	return level_data.keys()
