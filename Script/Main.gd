extends Node2D

#This main script is to store bullet and palyer, and signal call

const Player = preload("res://Scene/Player.tscn")


onready var baseManager = $BaseManager
onready var allyAI = $AllyMapAI
onready var enemyAI = $EnemyMapAI
onready var bulletManager = $BulletManager
onready var camera = $Camera2D
onready var gui = $GUI
onready var ground = $Ground
onready var pathfinding = $Pathfinding


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	GlobalSignal.connect("bulletFired", bulletManager, "bulletSpawned")
	
	var allyRespawn = $AllyRespawnPoint
	var enemyRespawn = $EnemyRespawnPoint
	
	pathfinding.create_navi_map(ground)
	
	var bases = baseManager.getCaptureBases()
	allyAI.initialize(bases, allyRespawn.get_children(), pathfinding)
	enemyAI.initialize(bases, enemyRespawn.get_children(), pathfinding)
	
	
	spawn_player()

func spawn_player():
	var player = Player.instance()
	add_child(player)
	player.set_camera_transform(camera.get_path())
	player.connect("died", self, "spawn_player")
	gui.set_player(player)

