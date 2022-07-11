extends Node

var _save: SaveGame

onready var _playerStats = PlayerStats
onready var _camera: Camera2D = null
onready var _cameraZoom = Vector2(0.7, 0.7)

func _create_save():
		_save = SaveGame.new()
		
		_playerStats.save_start_data(_save)
		_save.camera_zoom = _cameraZoom
		_save.write_savegame()

func _load_save():
	_save = SaveGame.load_savegame() as SaveGame
	_playerStats.load_data(_save)
	_cameraZoom = _save.camera_zoom

func _save_game():
	_playerStats.save_data(_save)
	_save.camera_zoom = _cameraZoom
	_save.write_savegame()
