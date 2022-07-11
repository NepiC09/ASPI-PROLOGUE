class_name SaveGame
extends Resource

const SAVE_GAME_PATH = "user://save.tres"

export var version = 1

export var map_path = ""
export var player_position = Vector2.ZERO
export var camera_zoom = Vector2.ZERO

func write_savegame():
# warning-ignore:return_value_discarded
	ResourceSaver.save(SAVE_GAME_PATH, self)

static func save_exists():
	return ResourceLoader.exists(SAVE_GAME_PATH)

static func load_savegame():
	if not ResourceLoader.has_cached(SAVE_GAME_PATH):
		return ResourceLoader.load(SAVE_GAME_PATH, "", true)
	
	var file = File.new()
	if file.open(SAVE_GAME_PATH, File.READ) != OK:
		printerr("Couldn't read file " + SAVE_GAME_PATH)
		return null
	
	var data = file.get_as_text()
	file.close()
	
	var tmp_file_path = make_random_path()
	while ResourceLoader.has_cached(tmp_file_path):
		tmp_file_path = make_random_path()
	
	if file.open(tmp_file_path, File.WRITE) != OK:
		printerr("Couldn't write file " + SAVE_GAME_PATH)
		return null
	
	file.store_string(data)
	file.close()
	
	var save = ResourceLoader.load(tmp_file_path, "", true)
	save.take_over_path(SAVE_GAME_PATH)
	
	var directory := Directory.new()
# warning-ignore:return_value_discarded
	directory.remove(tmp_file_path)
	return save

static func make_random_path() -> String:
	return "user://temp_file_" + str(randi()) + ".tres"
