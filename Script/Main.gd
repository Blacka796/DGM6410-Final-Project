extends Node2D

#This main script is to store bullet and palyer, and signal call

onready var bulletManager = $BulletManager
onready var player: Player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	GlobalSignal.connect("bulletFired", bulletManager, "bulletSpawned")

