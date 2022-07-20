extends Resource
class_name Character

#ВСЕ EXPORT ДАННЫЕ БУДУТ СОХРАНЕНЫ ИЛИ ПЕРЕЗАПИСАНЫ

export var Name: String = "" #Имя персонажа 
export var NameKnown: bool = false
export var dialogPath: String = "" #путь до файла с диалогами этого персонажа
export var phraseNum = 0 #на какой фразе диалог (возможно нужно добавить какой уровень диалога (?)
export var dialogNum = 0 #какой конкретно диалог идёт
export var position: Vector2 = Vector2.ZERO #где заспавнить персонажа (фича будет добавлена в будущем)
export var mapPath: String = "" #на какой карте заспавнить (фича будет в будущем)

