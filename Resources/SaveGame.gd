class_name SaveGame
extends Resource

#здесь путь к сохранениям
#Чтобы сделать больше сохранений, нужно будет добавить ещё пути save1.tres, save2.tres
const SAVE_GAME_PATH = "user://save.tres"

#данные которые будут сохранены
export var map_path = ""
export var player_position = Vector2.ZERO
export var camera_zoom = Vector2.ZERO
export var character_list: Resource #самое правильно использование ресурсов в сохранении

#функция сохранения данных
func write_savegame():
# warning-ignore:return_value_discarded
	ResourceSaver.save(SAVE_GAME_PATH, self) #сохраняет самого себя в файле 

#функция провверки существования сейва
static func save_exists():
	return ResourceLoader.exists(SAVE_GAME_PATH)

#функция загрузки сейва
static func load_savegame(): 
	#тут непонятно пока - надо читать доку
#	if not ResourceLoader.has_cached(SAVE_GAME_PATH):
#		return ResourceLoader.load(SAVE_GAME_PATH, "", true)
	
	#создание нового файла
	var file = File.new()
	#открываем файл в режиме чтения и проверяем успешно ли получилось
	if file.open(SAVE_GAME_PATH, File.READ) != OK:
		printerr("Couldn't read file " + SAVE_GAME_PATH)
		return null
	
	#записываем данные в качестве текста
	var data = file.get_as_text()
	file.close() #закрываем файл
	
	#этот момент я не понял
	var tmp_file_path = make_random_path() #создаётся рандомны путь, который ещё не был использован
	while ResourceLoader.has_cached(tmp_file_path):
		tmp_file_path = make_random_path()
	
	#открываем tmp в режиме записи и проверяем на успешность
	if file.open(tmp_file_path, File.WRITE) != OK:
		printerr("Couldn't write file " + SAVE_GAME_PATH)
		return null
	
	#сохранение данных
	file.store_string(data)
	file.close()
	
	#
	var save = ResourceLoader.load(tmp_file_path, "", true)
	save.take_over_path(SAVE_GAME_PATH)
	
	var directory := Directory.new()
# warning-ignore:return_value_discarded
	directory.remove(tmp_file_path)
	return save

static func make_random_path() -> String:
	return "user://temp_file_" + str(randi()) + ".tres"
