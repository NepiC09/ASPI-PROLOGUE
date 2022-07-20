extends Control

onready var answer0Box = $VBoxContainer/Answer0
onready var answer1Box = $VBoxContainer/Answer1
onready var answer2Box = $VBoxContainer/Answer2

onready var answer0 = $VBoxContainer/Answer0/AnswerText
onready var answer1 = $VBoxContainer/Answer1/AnswerText
onready var answer2 = $VBoxContainer/Answer2/AnswerText

onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer

var answer0Text = ""
var answer1Text = ""
var answer2Text = ""

var answer0Action = "" setget set_answer0
var answer1Action = "" setget set_answer1
var answer2Action = "" setget set_answer2

var num_of_answer = ""
signal actionSignal

func set_answer0(value):
	timer.start()
	disable_buttons(true)
	answer0Action = value
	answer0.text = answer0Text
	answer0Box.visible = true
	yield(timer, "timeout")
	disable_buttons(false)

func _unhandled_input(_event):
	if Input.is_action_pressed("1") and answer0.disabled != true:
		answer0.set_pressed(true)
		answer0.emit_signal("pressed")
	elif Input.is_action_pressed("2") and answer1Box.visible and answer1.disabled != true:
		answer1.pressed = true
		answer1.emit_signal("pressed")
	elif Input.is_action_pressed("3") and answer2Box.visible and answer2.disabled != true:
		answer2.pressed = true
		answer2.emit_signal("pressed")

func set_answer1(value):
	answer1Action = value
	answer1.text = answer1Text
	answer1Box.visible = true

func set_answer2(value):
	answer2Action = value
	answer2.text = answer2Text
	answer2Box.visible = true


func _on_Answer0_pressed():
	num_of_answer = "0"
	disable_buttons(true)
	animationPlayer.play("FirstChoosed")


func _on_Answer1_pressed():
	num_of_answer = "1"
	disable_buttons(true)
	animationPlayer.play("SecondChoosed")


func _on_Answer2_pressed():
	num_of_answer = "2"
	disable_buttons(true)
	animationPlayer.play("ThirdChoosed")


func disable_buttons(_bool : bool):
	answer0.disabled = _bool
	answer1.disabled = _bool
	answer2.disabled = _bool

func set_default():
	animationPlayer.play("RESET")

func _on_animation_finished(_anim_name):
	timer.start()
	yield(timer, "timeout")
	answer2Box.visible = false
	answer1Box.visible = false
	answer0Box.visible = false
	set_default()
	visible = false
	emit_signal("actionSignal", num_of_answer)
	num_of_answer = ""
