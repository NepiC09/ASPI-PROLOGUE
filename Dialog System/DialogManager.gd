extends Node2D

var NPC :KinematicBody2D = null
var player :KinematicBody2D = null

var NPC_TextBox :Node2D = null
var player_TextBox :Node2D = null

var character :Character = null

var dialogue
var lines: int
var textSpeed = 0.05

var finished = false
var action = ""

func _ready():
	NPC.set_direction(player.position - NPC.position) 
	player.set_direction(NPC.position - player.position)
	
	NPC.state = NPC.DIALOGUE
	player.state = player.DIALOGUE
	
	NPC_TextBox = NPC.textBox
	player_TextBox = player.textBox
	
	fade_animation(0)
	
	character = NPC.character
	player_TextBox.connect("actionSignal", self, "_on_AnswerBox_actionSignal")
	
	dialogue = get_dialogue(); assert(dialogue, "Dialog not found")
	next_phrase()


#процесс диалога
func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("LeftMouse"):
		if NPC_TextBox.finished and (action == "Continue" or action == "Open Name"):
			character.phraseNum += 1
			next_phrase()


func next_phrase():
	if(character.phraseNum >= len(dialogue[character.dialogNum])): #если фразы закончились
		NPC.state = NPC.MOVE
		player.state = player.MOVE
		queue_free()
		return
	
	
	NPC_TextBox._text = dialogue[character.dialogNum][character.phraseNum as String]["Text"]
	
	action = dialogue[character.dialogNum][character.phraseNum as String]["Action"]
	
	if action == "Answer":
		set_answers()
	elif action == "Open Name":
		character.NameKnown = true


func set_answers():
	fade_animation(1)
	
	var answers = dialogue[character.dialogNum][character.phraseNum as String]["Answer"]
	var numAnswers = len(answers)
	
	if numAnswers >= 1:
		player_TextBox._speach1 = answers["0"]["Text"]
	if numAnswers >= 2:
		player_TextBox._speach2 = answers["1"]["Text"]
	if numAnswers >= 3:
		player_TextBox._speach3 = answers["2"]["Text"]


func _on_AnswerBox_actionSignal(_answer: String):
	var answers = dialogue[character.dialogNum][character.phraseNum as String]["Answer"]
	var answerAction = answers[_answer]["Action"]
	if answerAction == "Stop dialogue":
		character.phraseNum = len(dialogue[character.dialogNum])
		quit_dialog()
	elif answerAction == "Continue In Line":
		character.phraseNum = answers[_answer]["In Line"] as int
		next_phrase()
		fade_animation(0)

func quit_dialog():
		NPC.state = NPC.MOVE
		player.state = player.MOVE
		
		fade_animation(3)

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

func fade_animation(side):
	var fade_speed = 0.3
	if side == 0 or side == 1:
		NPC_TextBox.visible = abs(side - 1) 
		player_TextBox.visible = side 
		
		$Tween.interpolate_property(NPC_TextBox, "modulate:a", side, abs(side-1), 
								fade_speed,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		$Tween.interpolate_property(player_TextBox, "modulate:a", abs(side-1), side, 
								fade_speed,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
	
	else:
		side -= 2
		if side == 0:
			NPC_TextBox.visible = true
			player_TextBox.visible = true
		
		$Tween.interpolate_property(NPC_TextBox, "modulate:a", side, abs(side-1), 
									fade_speed, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		$Tween.interpolate_property(player_TextBox, "modulate:a", side, abs(side-1), 
									fade_speed,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		
		yield($Tween,"tween_all_completed")
		if side == 1:
			NPC_TextBox.visible = false
			player_TextBox.visible = false
			queue_free()
