extends Resource
class_name CharacterList

#ВСЕ EXPORT ДАННЫЕ БУДУТ СОХРАНЕНЫ ИЛИ ПЕРЕЗАПИСАНЫ
export var Aki: Resource
export var Test_Nobody: Resource #ПРОСТО ТАК

#ПЕРВОНАЧАЛЬНАЯ НАСТРОЙКА ПЕРСОНАЖЕЙ
func set_characters():
	#ВСЕ ПЕРСОНАЖИ БУДУТ НАСТРОЕНЫ ПОДОБНЫМ ОБРАЗОМ
	Aki = Character.new(); 
	Aki.Name = "Aki"; 
	Aki.dialogPath = "res://Characters/NPC/Aki/Dialogs/test.json"
	
	Test_Nobody = Character.new(); Test_Nobody.Name = "Nobody"
	
