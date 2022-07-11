extends Control

onready var question = $Question
onready var background = $Background 
onready var buttonsColider = $ButtonsColider

onready var continueButton = $ButtonsColider/VBoxContainer/ContinueButton
onready var cancelButton = $Question/HBoxContainer/CancelMenuButton
onready var buttons = get_tree().get_nodes_in_group("buttons")
onready var fadeAnim = $UI/Fade/AnimationPlayer

var _globalData = GlobalData
var is_paused = false setget set_is_paused

enum{
	SAVE_DATA,
	LOAD_DATA,
	LOAD_MENU
}
var action = SAVE_DATA

func set_is_paused(value: bool):
	if value == false:
		question.visible = false
	is_paused = value
	get_tree().paused = is_paused
	self.visible = is_paused
	set_process(is_paused)
	continueButton.grab_focus()

func set_Fade():
	background.visible = false
	buttonsColider.visible = false
	question.visible = false

func _ready():
	set_process(false)

func _process(_delta):
	for button in buttons:
		if button.is_hovered():
			button.grab_focus()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func _on_ContinueButton_pressed():
	self.is_paused = false


func _on_SaveButton_pressed():
	_globalData._save_game()
	action = SAVE_DATA
	fadeAnim.play("FadeIn")


func _on_LoadSave_pressed():
	set_Fade()
	action = LOAD_DATA
	fadeAnim.play("FadeIn")


func _on_MainMenu_pressed():
	question.visible = true
	cancelButton.grab_focus()

func _on_YesMenuButton_pressed():
	set_Fade()
	_globalData._save_game()
	action = LOAD_MENU
	fadeAnim.play("FadeIn")

func _on_NoMenuButton_pressed():
	set_Fade()
	action = LOAD_MENU
	fadeAnim.play("FadeIn")

func _on_CancelMenuButton_pressed():
	continueButton.grab_focus()
	question.visible = false


func _on_UI_FadeInFinished():
		match action:
			SAVE_DATA:
				fadeAnim.play("FadeOut")
			LOAD_DATA:
				_globalData._load_save()
				self.is_paused = false
# warning-ignore:return_value_discarded
				get_tree().change_scene(_globalData._save.map_path)
			LOAD_MENU:
				self.is_paused = false
# warning-ignore:return_value_discarded
				get_tree().change_scene("res://GUI/Main Menu.tscn")
