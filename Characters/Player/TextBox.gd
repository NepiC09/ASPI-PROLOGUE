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
var textSpeed :float = 20
var finished = true

var currentSpeach = 1 setget set_currentSpeach
var numberOfAnswers = 1 setget set_numberOfAnswers

var width = 15

var _speach1 = "" setget set_speach1
var _speach2 = "" setget set_speach2
var _speach3 = "" setget set_speach3

signal actionSignal

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_left"):
		leftButton.emit_signal("pressed")
	if Input.is_action_just_pressed("ui_right"):
		rightButton.emit_signal("pressed")
	if Input.is_action_just_pressed("ui_accept"): 
		if finished:
			self.set_process_unhandled_input(false)
			set_select_visible(false)
			emit_signal("actionSignal", str(currentSpeach - 1))
			currentSpeach = 1
		elif !finished:
			speach1Text.visible_characters = -1
			finished = true

func _ready():
	self.set_process_unhandled_input(false)


func set_speach1(value):
	_speach1 = value
	speach1Text.bbcode_text = _speach1
	set_numberOfAnswers(1)
	set_x_size(len(speach1Text.text))
	text_anim()
	self.set_process_unhandled_input(true)

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
			set_x_size(len(speach1Text.text))
		2:
			speach1Text.bbcode_text = _speach2
			select1Sprite.visible = false
			select2Sprite.visible = true
			select3Sprite.visible = false
			set_x_size(len(speach1Text.text))
		3:
			speach1Text.bbcode_text = _speach3
			select1Sprite.visible = false
			select2Sprite.visible = false
			select3Sprite.visible = true
			set_x_size(len(speach1Text.text))

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
	var count = min(value, 17) - 1
	backPanel.rect_size.x = 30 + count * width
	backPanel.rect_position.x = -(backPanel.rect_size.x - 30)/2 - 15
	

func set_y_size(value):
	backPanel.rect_size.y = 31 + value*15
	backPanel.rect_position.y = -43 - (backPanel.rect_size.y - 31)


func _on_LeftButton_pressed():
	set_currentSpeach(max(currentSpeach - 1, 1))


func _on_RightButton_pressed():
	finished = true
	speach1Text.visible_characters = -1
	set_currentSpeach(min(currentSpeach +1 , numberOfAnswers))


func _on_Speach1_resized():
	var lines = ceil(speach1Text.rect_size.y/19)
	set_y_size(lines - 1)

func set_select_visible(_bool: bool):
	select1.visible = _bool
	select2.visible = _bool
	select3.visible = _bool
	leftButton.visible = _bool
	rightButton.visible = _bool

func text_anim():
	finished = false
	speach1Text.visible_characters = 0
	while speach1Text.visible_characters < len(speach1Text.text) and !finished:
		speach1Text.visible_characters += 1
		timer.wait_time = 1 / textSpeed
		timer.start()
		yield(timer, "timeout")
#		set_x_size(speach1Text.visible_characters)
	finished = true
