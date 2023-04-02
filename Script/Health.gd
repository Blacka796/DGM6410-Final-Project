extends Node2D

#This script is to store both player and enemy's health

export var health = 100 setget setHealth# Set the value for player and enemy's health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setHealth(newHealth):
	health = clamp(newHealth, 0, 160)
