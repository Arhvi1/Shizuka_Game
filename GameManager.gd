extends Node

var visited_scenes: Dictionary = {}

const REQUIRED_SCENES: Array[String] = ["balcony", "bath", "street"]
const FINAL_SCENE_PATH: String = "res://Scenes/Maps/final_scene.tscn"


func mark_scene_as_visited(scene_name: String):
	visited_scenes[scene_name] = true
	print("✓ Сцена посещена: ", scene_name)

func is_scene_visited(scene_name: String) -> bool:
	return visited_scenes.get(scene_name, false)

func are_all_scenes_visited() -> bool:
	for scene in REQUIRED_SCENES:
		if not is_scene_visited(scene):
			return false
	return true

func get_visited_count() -> int:
	var count = 0
	for scene in REQUIRED_SCENES:
		if is_scene_visited(scene):
			count += 1
	return count
