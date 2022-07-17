extends Position2D

#ссылки на дочерние узлы сцены
onready var sizeCorrect = $SizeCorrect
onready var polygon: Polygon2D = $SizeCorrect/HBoxContainer/TextBox/DialogBackground
onready var char_name: RichTextLabel = $SizeCorrect/HBoxContainer/TextBox/Name
onready var text: RichTextLabel = $SizeCorrect/HBoxContainer/TextBox/Text
onready var timer = $Timer

#доступ к глобальным данным
var _globalData = GlobalData
#ссылки на объекты дерева
var camera = GlobalData._camera
var player = GlobalData._playerStats.player

#экспортируемые - изменяемые значения
export (float) var textSpeed = 0.05

#переменные
var character :Character #диалого какого персонажа будет проигрываться и его данные
var dialog #сам диалог в форме массива

var lines: float

var needToDelete = false #нужно для удаления объекта через персонажа, который вызвал это окно
var finished = false #показан ли весь текст


func _ready():
	set_camera() #настройка камеры
	timer.wait_time = textSpeed #установка скорости показа текста
	dialog = getDialog(); assert(dialog, "Dialog not found") #получения диалога из файла в виде массива
	char_name.bbcode_text = character.Name #устанавливает имя персонажа
	nextPhrase() #процесс диалога

#продолжение диалога
func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		if finished: #если весь текст показан - переход к следующей фразе
			nextPhrase()
		else: #если не весь текст показан - показывает весь текст
			text.visible_characters = len(text.text)


#изменения диалогового окошка
func change_polygon(value:float):
	var _polygon :PoolVector2Array
	_polygon = polygon.get_polygon()
	_polygon[2].y += value
	_polygon[3].y += value
	_polygon[4].y += value
	polygon.set_polygon(_polygon)

#получения диалога в виде массива из JSON файла
func getDialog() -> Array:
	var file = File.new() 
	#проверка на существование файла
	assert(file.file_exists(character.dialogPath), "File path doesn't exist")
	
	file.open(character.dialogPath, file.READ) #открытие файла в режиме чтения
	var json = file.get_as_text() #получения данных в виде текста
	
	var output = parse_json(json) #получения текста в виде массива
	#проверка - являются ли данные массивом
	if typeof(output) == TYPE_ARRAY: 
		return output 
	else: 
		return []

#настройка камеры
func set_camera():
# warning-ignore:return_value_discarded
	camera.connect("zoom_changed", self, "_on_zoom_changed")
	_on_zoom_changed()

func _on_zoom_changed():
	sizeCorrect.rect_scale.x = camera.zoom.x * 3
	sizeCorrect.rect_scale.y = camera.zoom.x * 3
	sizeCorrect.rect_position.y = (sizeCorrect.rect_scale.x - 1) * 48 + (camera.zoom.x) * 64
	sizeCorrect.rect_position.y += (4 - lines) * (camera.zoom.x) * 32

#процесс диалога (ВОТ ЭТО НУЖНО МЕНЯТЬ)
func nextPhrase():
	if(character.phraseNum >= len(dialog)): #если фразы закончились
		needToDelete = true #"говорит", что нужно удалить это окошко
		return
	
	#устанавливается текст фразы из массива
	text.bbcode_text = dialog[character.phraseNum]["Text"]
	
	text.visible_characters = 0 #обнуляет показанный текст
	finished = false #не весь текст показан
	
	lines = text.rect_size.y / 11.0 #считает количество линий
	change_polygon((lines - 1)*11) #ставит размер фона под размер текста
	_on_zoom_changed() #изменяет позицию фона под размер текста
	
	#цикл - пока не будут отображены все символы
	while text.visible_characters < len(text.text):
		text.visible_characters += 1
		
		timer.start()
		yield(timer, "timeout")
	
	finished = true #все символы отображены
	character.phraseNum += 1 #переход к следующей фразе
