extends Control

onready var textBox :RichTextLabel = $Text
onready var nameBox :RichTextLabel = $Name

var _text = "" setget set_text
var _name = "" setget set_name

func set_text(value: String):
	_text = value
	textBox.bbcode_text = _text

func set_name(value: String):
	_name = value
	nameBox.bbcode_text = _name
