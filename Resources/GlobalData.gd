extends Node

#ссылка на сохранения - именно там происходит сохранения
var _save: SaveGame

#здесь хранятся глобальные данные, для удобства получения каждого объекта и настройки их
onready var _playerStats = PlayerStats #игрок
onready var _camera: Camera2D = null #камера
onready var _cameraZoom = Vector2(0.7, 0.7) #её зум
onready var _characterList = null #список персонажей. Пока только они правильно используют сохранения ресурсов
 
#создание файла сохранения
func _create_save():
	#создание экземпляра сохранения
	_save = SaveGame.new()
	
	#настройка, создание экземпляров данных
	_save.character_list = CharacterList.new()
	_save.character_list.set_characters()
	_playerStats.save_start_data(_save)
	_save.camera_zoom = _cameraZoom
	
	_save.write_savegame() #сохранить 

#загрузка сохранений
func _load_save():
	#выгрузка данных
	_save = SaveGame.load_savegame() as SaveGame
	#присвоение данных
	_characterList = _save.character_list
	_playerStats.load_data(_save)
	_cameraZoom = _save.camera_zoom

#сохранение игры
func _save_game():
	_playerStats.save_data(_save)
	_save.camera_zoom = _cameraZoom
	_save.character_list = _characterList
	_save.write_savegame()
