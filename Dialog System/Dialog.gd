extends Position2D

onready var sizeCorrect = $SizeCorrect
onready var dialogueBackground = $SizeCorrect/HBoxContainer/TextBox/DialogBackground
onready var timer = $Timer

onready var TextBox = $SizeCorrect/HBoxContainer/TextBox
onready var AnswerBox = $SizeCorrect/HBoxContainer/AnswerBox

var speaker1 :KinematicBody2D = null
var speaker2 :KinematicBody2D = null

var character :Character = null

var dialogue
var lines: int
var textSpeed = 0.05

var finished = false
var action = ""

func _ready():
	timer.wait_time = textSpeed #установка скорости показа текста
	
	speaker1.set_direction(speaker2.position - speaker1.position) 
	speaker2.set_direction(speaker1.position - speaker2.position)
	speaker1.state = speaker1.DIALOGUE
	speaker2.state = speaker2.DIALOGUE
	character = speaker1.character
	if character.NameKnown == true:
		TextBox._name = character.Name
	dialogue = get_dialogue(); assert(dialogue, "Dialog not found")
	next_phrase()


#процесс диалога
func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		if finished and (action == "Continue" or action == "Open Name"):
			character.phraseNum += 1
			next_phrase()
		else:
			TextBox.textBox.visible_characters = len(TextBox._text)


func next_phrase():
	if(character.phraseNum >= len(dialogue[character.dialogNum])): #если фразы закончились
		speaker1.state = speaker1.MOVE
		speaker2.state = speaker2.MOVE
		queue_free()
		return
		
	TextBox._text = dialogue[character.dialogNum][character.phraseNum as String]["Text"]
	
	TextBox.textBox.visible_characters = 0 #обнуляет показанный текст
	finished = false #не весь текст показан
	
	#цикл - пока не будут отображены все символы
	while TextBox.textBox.visible_characters < len(TextBox.textBox.text):
		TextBox.textBox.visible_characters += 1
		
		timer.start()
		yield(timer, "timeout")
		lines = (TextBox.textBox.rect_size.y + 11) / 11.0
		set_background(lines)
	
	finished = true #все символы отображены
	
	action = dialogue[character.dialogNum][character.phraseNum as String]["Action"]
	if action == "Answer":
		set_answers()
	elif action == "Open Name":
		TextBox._name = character.Name
		character.NameKnown = true


func set_answers():
	var answers = dialogue[character.dialogNum][character.phraseNum as String]["Answer"]
	var numAnswers = len(answers)
#	AnswerBox.animationPlayer.play("RESET")
	if numAnswers >= 1:
		if lines < 1: set_background(1)
		AnswerBox.answer0Text = answers["0"]["Text"]
		AnswerBox.answer0Action = answers["0"]["Action"]
	if numAnswers >= 2:
		if lines < 3: set_background(3)
		AnswerBox.answer1Text = answers["1"]["Text"]
		AnswerBox.answer1Action = answers["1"]["Action"]
	if numAnswers >= 3:
		if lines <5: set_background(5)
		AnswerBox.answer2Text = answers["2"]["Text"]
		AnswerBox.answer2Action = answers["2"]["Action"]
	AnswerBox.visible = true
	AnswerBox.answer0.grab_focus()


#получение диалога в виде массива
func get_dialogue() -> Array:
	var file = File.new() 
	assert(file.file_exists(character.dialogPath), "File path doesn't exist")
	file.open(character.dialogPath, file.READ)
	
	var json = file.get_as_text()
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY: 
		return output 
	else: 
		return []


#изменения диалогового окошка
func set_background(_lines):
	var _polygon :PoolVector2Array
	_polygon = dialogueBackground.get_polygon()
	_polygon[2].y = 23 + (_lines - 1) * 11
	_polygon[3].y = 28 + (_lines - 1) * 11
	_polygon[4].y = 28 + (_lines - 1) * 11
	dialogueBackground.set_polygon(_polygon)
	sizeCorrect.rect_position.y = 102 - (_lines - 1) * 0.6 * 32


func _on_AnswerBox_actionSignal(_answer: String):
	var answers = dialogue[character.dialogNum][character.phraseNum as String]["Answer"]
	var answerAction = answers[_answer]["Action"]
	if answerAction == "Stop dialogue":
		speaker1.state = speaker1.MOVE
		speaker2.state = speaker2.MOVE
		character.dialogNum += 1 #ВРЕМЕННОЕ РЕШЕНИЕ - В ДАЛЬНЕЙШЕМ БУДЕТ DEFAULT
		queue_free()
	elif answerAction == "Continue In Line":
		character.phraseNum = answers[_answer]["In Line"] as int
		next_phrase()
