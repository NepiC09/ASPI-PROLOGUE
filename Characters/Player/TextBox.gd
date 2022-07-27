extends Node2D

onready var backPanel = $BackPanel
onready var speach1Text = $BackPanel/Speach1

onready var leftButton = $LeftButton
onready var rightButton = $RightButton

onready var select1 = $SelectContainer/Select1
onready var select2 = $SelectContainer/Select2
onready var select3 = $SelectContainer/Select3
onready var select1Sprite = $SelectContainer/Select1/Selected
onready var select2Sprite = $SelectContainer/Select2/Selected
onready var select3Sprite = $SelectContainer/Select3/Selected

onready var timer = $Timer


var currentSpeach = 1 setget set_currentSpeach
var numberOfAnswers = 1 setget set_numberOfAnswers

var width = 7

var _speach1 = "" setget set_speach1
var _speach2 = "" setget set_speach2
var _speach3 = "" setget set_speach3


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_left"):
		leftButton.emit_signal("pressed")
	if Input.is_action_just_pressed("ui_right"):
		rightButton.emit_signal("pressed")


func set_speach1(value):
	_speach1 = value
	speach1Text.bbcode_text = _speach1
	set_numberOfAnswers(1)

func set_speach2(value):
	_speach2 = value
	set_numberOfAnswers(2)

func set_speach3(value):
	_speach3 = value
	set_numberOfAnswers(3)

func set_currentSpeach(value):
	currentSpeach = value
	match currentSpeach:
		1:
			speach1Text.bbcode_text = _speach1
			select1Sprite.visible = true
			select2Sprite.visible = false
			select3Sprite.visible = false
			set_x_size(len(_speach1))
		2:
			speach1Text.bbcode_text = _speach2
			select1Sprite.visible = false
			select2Sprite.visible = true
			select3Sprite.visible = false
			set_x_size(len(_speach2))
		3:
			speach1Text.bbcode_text = _speach3
			select1Sprite.visible = false
			select2Sprite.visible = false
			select3Sprite.visible = true
			set_x_size(len(_speach3))

func set_numberOfAnswers(value: int):
	numberOfAnswers = value
	if numberOfAnswers == 1:
		position.y = -36
	if numberOfAnswers >= 2:
		position.y = -58
		select1.visible = true
		select2.visible = true
		leftButton.visible = true
		rightButton.visible = true
	if numberOfAnswers == 3:
		select3.visible = true

func set_x_size(value):
	var count = clamp(value, 6, 17) - 6
	backPanel.rect_size.x = 100 + count * width
	backPanel.rect_position.x = -(backPanel.rect_size.x - 100)/2 - 50
	

func set_y_size(value):
	backPanel.rect_size.y = 31 + value*15
	backPanel.rect_position.y = -43 - (backPanel.rect_size.y - 31)


func _on_LeftButton_pressed():
	set_currentSpeach(max(currentSpeach - 1, 1))


func _on_RightButton_pressed():
	set_currentSpeach(min(currentSpeach +1 , numberOfAnswers))


func _on_Speach1_resized():
	var lines = ceil(speach1Text.rect_size.y/19)
	set_y_size( lines - 1)
