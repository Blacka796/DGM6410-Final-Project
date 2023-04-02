extends CanvasLayer

onready var UIplayer = $PanelContainer/MarginContainer/UI/UIPlayer


func _ready():
	UIplayer.play("UI")


func _on_Play_pressed():
	get_tree().change_scene("res://Scene/Main.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Control_pressed():
	get_tree().change_scene("res://UI/ControlScene.tscn")


func _on_Credit_pressed():
	get_tree().change_scene("res://UI/CreditScene.tscn")
