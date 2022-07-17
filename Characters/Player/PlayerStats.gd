extends Node

#это первональные значения при "Новой игре"
const START_PLAYER_POSITION = Vector2(819, 342)
const START_MATH_PATH = "res://Maps/Interior Example.tscn"

#глобальная ссылка на игрока
onready var player :KinematicBody2D
#место куда нужно перейти и где создать персонажа
onready var spawnPosition = Vector2.ZERO
onready var map_path = ""

#настройка сохранений
#ВСЁ МОЖНО СДЕЛАТЬ ПРОЩЕ ЧЕРЕЗ РЕСУРСЫ
func load_data(_save: SaveGame):
	spawnPosition = _save.player_position
	map_path = _save.map_path

func save_data(_save: SaveGame):
	_save.player_position = player.position
	_save.map_path = player.get_tree().current_scene.get_filename()

func save_start_data(_save: SaveGame):
	_save.player_position = START_PLAYER_POSITION
	_save.map_path = START_MATH_PATH
