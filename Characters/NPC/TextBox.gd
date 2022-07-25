extends Node2D

onready var Text = $TextControl/Text
onready var backPanel = $BackPanel
onready var textControl = $TextControl
onready var timer = $Timer


var _text = "" setget set_text
var textSpeed :float = 20
var width = 7
var finished = false

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("LeftMouse"):
		if !finished:
			Text.visible_characters = len(_text)

func set_text(value):
	#настройка размеров и положения
	_text = value
	Text.bbcode_text =_text
	set_x_size(len(_text))
	
	finished = false
	Text.visible_characters = 0
	timer.wait_time = 1 / textSpeed
	
	while Text.visible_characters < len(_text):
		Text.visible_characters += 1
		
		timer.start()
		yield(timer, "timeout")
		var lines = ceil((Text.rect_size.y) / 11)
		set_y_size(lines - 1)
	finished = true


func set_x_size(value: int):
	var count = min(value, 17) - 6
	backPanel.rect_size.x = 88 + count * width
	backPanel.rect_position.x = -(backPanel.rect_size.x - 88)/2 - 44
	textControl.rect_size.x = 72 + count * width
	textControl.rect_position.x = -(textControl.rect_size.x - 72)/2 -36
	Text.rect_size.x = textControl.rect_size.x / 1.7

func set_y_size(value: int):
	backPanel.rect_size.y = 38 + value*15
	backPanel.rect_position.y = -39 - value*15
	textControl.rect_position.y = -33 - value*15
