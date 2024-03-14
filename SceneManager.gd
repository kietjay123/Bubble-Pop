extends Node

@export var scenes : Dictionary = {}

var currentSceneAlias : String = ""


func addScene(sceneAlias : String, scenePath : String) -> void :
	scenes[sceneAlias] = scenePath


func removeScene(sceneAlias : String) -> void :
	scenes.erase(sceneAlias)


func changeScene(sceneAlias : String) -> void :
	get_tree().change_scene_to_file(scenes[sceneAlias])

func restartScene() -> void :
	get_tree().reload_current_scene()

func quitGame() -> void :
	get_tree().quit()

func _ready():
	var mainScene : String = ProjectSettings.get_setting("application/run/main_scene")
	for i in scenes.keys() :
		if scenes[i] == mainScene :
			currentSceneAlias = i
