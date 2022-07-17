extends "res://Characters/NPC/NPC.gd"

#получаем доступ к глобальным ресурсам для настройки character
var _globalData = GlobalData

func _ready():
	character = _globalData._characterList.Aki #сообщаем, что этот объект является "Aki"
