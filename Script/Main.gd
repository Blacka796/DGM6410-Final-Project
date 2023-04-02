extends Node2D

#This main script is to store bullet and palyer, and signal call

const Player = preload("res://Scene/Player.tscn")
const GameOverScreen = preload("res://UI/GameOverScreen.tscn")
const PauseScreen = preload("res://UI/PauseScreen.tscn")


onready var baseManager = $BaseManager
onready var allyAI = $AllyMapAI
onready var enemyAI = $EnemyMapAI
onready var bulletManager = $BulletManager
onready var camera = $Camera2D
onready var gui = $GUI
onready var ground = $Ground
onready var pathfinding = $Pathfinding
onready var backgroundMusic = $BackgroundMusic


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
	baseManager.connect("player_get_all_bases", self, "handle_player_win")
	baseManager.connect("player_lose_all_bases", self, "handle_player_lose")
	
	
	spawn_player()

	backgroundMusic.play()

func spawn_player():
	var player = Player.instance()
	add_child(player)
	player.set_camera_transform(camera.get_path())
	player.connect("died", self, "spawn_player")
	gui.set_player(player)


func handle_player_win():
	var gameOver = GameOverScreen.instance()
	add_child(gameOver)
	gameOver.set_title(true)
	get_tree().paused = true
	
	
func handle_player_lose():
	var gameOver = GameOverScreen.instance()
	add_child(gameOver)
	gameOver.set_title(false)
	get_tree().paused = true


func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		var pauseMenu = PauseScreen.instance()
		add_child(pauseMenu)
