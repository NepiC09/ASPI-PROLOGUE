extends Control
onready var fadeAnim = $Fade/Fade/AnimationPlayer
onready var continueButton = $VBoxContainer/ContinueButton
onready var question = $Question
onready var cancelButton = $Question/HBoxContainer/CancelButton

var _globalData = GlobalData

enum{
	NEW_GAME,
	CONTINUE,
	OPTION,
	QUICK
}
var action = CONTINUE
var buttons

#starting focus on Start Button
func _ready():
	question.visible = false
	buttons = get_tree().get_nodes_in_group("buttons")
	continueButton.grab_focus()
	if SaveGame.save_exists():
		continueButton.disabled = false
		_globalData._save = SaveGame.load_savegame() as SaveGame
	else:
		continueButton = true

#getting right focused
func _process(_delta):
	for button in buttons:
		if button.is_hovered():
			button.grab_focus()

func _on_NewGameButton_pressed():
	if SaveGame.save_exists():
		question.visible = true
		cancelButton.grab_focus()
	else:
		_on_DeleteButton_pressed()

func _on_ContinueButton_pressed():
	fadeAnim.play("FadeIn")
	action = CONTINUE

func _on_OptionButton_pressed():
	fadeAnim.play("FadeIn")
	action = OPTION

func _on_QuickButton_pressed():
	fadeAnim.play("FadeIn")
	action = QUICK

func _on_UI_FadeInFinished():
	match action:
		NEW_GAME:
			_globalData._create_save()
			_globalData._load_save()
# warning-ignore:return_value_discarded
			get_tree().change_scene(_globalData._save.map_path)
		CONTINUE:
			_globalData._load_save()
# warning-ignore:return_value_discarded
			get_tree().change_scene(_globalData._save.map_path)
		OPTION:
			pass
		QUICK:
			get_tree().quit()


func _on_DeleteButton_pressed():
	fadeAnim.play("FadeIn")
	action = NEW_GAME


func _on_CancelButton_pressed():
	question.visible = false
	continueButton.grab_focus()
