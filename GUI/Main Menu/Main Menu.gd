extends Control

#ссылки на дочерние узлы сцены
onready var fadeAnim = $Fade/Fade/AnimationPlayer
onready var continueButton = $VBoxContainer/ContinueButton
onready var question = $Question
onready var cancelButton = $Question/HBoxContainer/CancelButton

#ссылки на группы
onready var buttons = get_tree().get_nodes_in_group("buttons")

#доступ к глобальным данным
var _globalData = GlobalData

#действия, которые будут выполнены после завершения анимации FadeIn
enum{
	NEW_GAME,
	CONTINUE,
	OPTION,
	QUICK
}

var action = CONTINUE


func _ready():
	question.visible = false #скрываем окошко с вопросом
	continueButton.grab_focus() #воруем фокус на кнопку
	if SaveGame.save_exists(): #если существуют сохранения
		continueButton.disabled = false #даём доступ к кнопке "продолжить"
		_globalData._save = SaveGame.load_savegame() as SaveGame #загружаем сохранённые данные
	else: 
		continueButton = true #закрываем доступ к кнопке "продолжить"

#правильно настраиваем фокус с мышкой
func _process(_delta):
	for button in buttons:
		if button.is_hovered():
			button.grab_focus()

#если нажата кнопка "НОВАЯ ИГРА"
func _on_NewGameButton_pressed():
	if SaveGame.save_exists(): #проверка на существующие сохранения
		question.visible = true
		cancelButton.grab_focus()
	else: #если их нет, то создаём
		_on_DeleteButton_pressed()

#если нажата кнопка "ПРОДОЛЖИТЬ"
func _on_ContinueButton_pressed():
	fadeAnim.play("FadeIn") #включаем анимацию FadeIn
	action = CONTINUE #назначаем действие после анимации

#если нажата кнопка "ОПЦИИ" - ПОКА НИЧЕГО НЕТ
func _on_OptionButton_pressed():
	fadeAnim.play("FadeIn") #включаем анимацию FadeIn
	action = OPTION #назначаем действие после анимации

#если нажата кнопка "ВЫЙТИ ИЗ ИГРЫ"
func _on_QuickButton_pressed():
	fadeAnim.play("FadeIn") #включаем анимацию FadeIn
	action = QUICK #назначаем действие после анимации

#КНОПКИ ПОСЛЕ ВОПРОСА
#ЕСЛИ НАЖАТО "УДАЛИТЬ СОХРАНЕНИЯ"
func _on_DeleteButton_pressed():
	fadeAnim.play("FadeIn") #включаем анимацию FadeIn
	action = NEW_GAME #назначаем действие после анимации

#ЕСЛЛИ НАЖАТО ОТМЕНА
func _on_CancelButton_pressed():
	question.visible = false #убираем окошко вопроса
	continueButton.grab_focus() #крадём фокус

#Когда завершилась анимация
func _on_UI_FadeInFinished():
	match action:
		NEW_GAME: #НОВАЯ ИГРА
			_globalData._create_save() #СОЗДАТЬ СЕЙВ
			_globalData._load_save() #ЗАГРУЗИТЬ СЕЙВ
# warning-ignore:return_value_discarded
			#СМЕНА КАРТЫ
			get_tree().change_scene(_globalData._save.map_path)
		CONTINUE: #ПРОДОЛЖИТЬ ИГРУ
			_globalData._load_save() #ЗАГРУЗИТЬ СЕЙВ
# warning-ignore:return_value_discarded
			#СМЕНА КАРТЫ 
			get_tree().change_scene(_globalData._save.map_path)
		OPTION: #ОПЦИИ
			pass #ПОКА НИЧЕГО НЕТ
		QUICK: #ВЫХОД ИЗ ИГРЫ
			get_tree().quit()
