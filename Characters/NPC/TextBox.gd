extends Node2D

onready var backPanel = $BackPanel
onready var Text = $BackPanel/Text
onready var timer = $Timer


var _text = "" setget set_text
var textSpeed :float = 20
var width = 15
var finished = false

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("LeftMouse"):
		Text.visible_characters = len(_text)

func set_text(value):
	self.set_process_unhandled_input(true)
	#настройка размеров и положения
	_text = value
	Text.bbcode_text =_text
	set_x_size(len(Text.text))
	
	finished = false
	Text.visible_characters = 0
	timer.wait_time = 1 / textSpeed
	
	while Text.visible_characters < len(_text):
		Text.visible_characters += 1
		
		timer.start()
		yield(timer, "timeout")
#		set_x_size(Text.visible_characters)
	finished = true
	self.set_process_unhandled_input(false)


func set_x_size(value: int):
	var count = min(value, 17) - 1
	backPanel.rect_size.x = 30 + count * width
	backPanel.rect_position.x = -(backPanel.rect_size.x - 30)/2 - 15

func set_y_size(value: int):
	backPanel.rect_size.y = 31 + value*15
	backPanel.rect_position.y = -39 - (backPanel.rect_size.y - 31)


func _on_Text_resized():
	var lines = ceil((Text.rect_size.y) / 19)
	set_y_size(lines - 1)
