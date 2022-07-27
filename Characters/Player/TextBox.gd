extends Node2D

onready var speach1Text = $BackPanel/Speach1
onready var speach3Text = $BackPanel/Speach2
onready var speach2Text = $BackPanel/Speach3
onready var backPanel = $BackPanel

onready var timer = $Timer

onready var leftButton = $LeftButton
onready var rightButton = $RightButton
onready var select1 = $SelectContainer/Select1/Selected
onready var select2 = $SelectContainer/Select2/Selected
onready var select3 = $SelectContainer/Select3/Selected

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

func _ready():
	speach1Text.visible = false
	speach2Text.visible = false
	speach3Text.visible = false


func set_speach1(value):
	_speach1 = value
	speach1Text.bbcode_text = _speach1

func set_speach2(value):
	_speach2 = value
	speach2Text.bbcode_text = _speach2

func set_speach3(value):
	_speach3 = value
	speach3Text.bbcode_text = _speach3

func set_currentSpeach(value):
	currentSpeach = value
	var lines = 0
	match currentSpeach:
		1:
			speach1Text.visible = true
			speach2Text.visible = false
			speach3Text.visible = false
			select1.visible = true
			select2.visible = false
			select3.visible = false
			set_x_size(len(_speach1))
			lines = ceil(speach1Text.rect_size.y/19)
		2:
			speach2Text.visible = true
			speach1Text.visible = false
			speach3Text.visible = false
			select1.visible = false
			select2.visible = true
			select3.visible = false
			set_x_size(len(_speach2))
			lines = ceil(speach2Text.rect_size.y/19)
		3:
			speach3Text.visible = true
			speach1Text.visible = false
			speach2Text.visible = false
			select1.visible = false
			select2.visible = false
			select3.visible = true
			set_x_size(len(_speach3))
			lines = ceil(speach3Text.rect_size.y/19)
	set_y_size(lines - 1)
	print(lines)

func set_numberOfAnswers(value: int):
	numberOfAnswers = value
	print("Number of answers: "+ str(numberOfAnswers))
	pass

func set_x_size(value):
	var count = clamp(value, 6, 17) - 6
	backPanel.rect_size.x = 100 + count * width
	backPanel.rect_position.x = -(backPanel.rect_size.x - 100)/2 - 50
	

func set_y_size(value):
	backPanel.rect_size.y = 32 + value*15
	backPanel.rect_position.y = -43 - value*15


func _on_LeftButton_pressed():
	set_currentSpeach(max(currentSpeach - 1, 1))


func _on_RightButton_pressed():
	set_currentSpeach(min(currentSpeach +1 , numberOfAnswers))
