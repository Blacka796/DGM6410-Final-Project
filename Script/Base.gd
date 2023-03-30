extends Area2D
class_name CaptureBase
#This script is for capturable base, which allows player and enemy to capture it

signal base_capture(newTeam)

export var neutral_color = Color(1, 1, 1)
export var player_color = Color(0.05098, 0.909804, 0.384314)
export var enemy_color = Color(0.94902, 0.180392, 0.145098)


var playerCount = 0 #var to count the time for player
var enemyCount = 0 #var to count the time for enemh
var teamToCapture = Team.TeamName.NEUTRAL


onready var team = $Team
onready var captureTimer = $CaptureTimer
onready var sprite = $Sprite
onready var collisionShape = $CollisionShape2D
onready var playerLabel = $Player
onready var enemyLabel = $Enemy



func _ready():
	playerLabel.text = "0"
	enemyLabel.text = "0"


func get_random_position_capture():
	var extents = collisionShape.shape.extents
	var top_left = collisionShape.global_position - (extents / 2)
	var x = rand_range(top_left.x, top_left.x + extents.x)
	var y = rand_range(top_left.y, top_left.y + extents.y)
	
	return Vector2(x, y)


func _on_Base_body_entered(body):
	if body.has_method("get_team"):
		var bodyTeam = body.get_team()
		if bodyTeam == Team.TeamName.ENEMY:
			enemyCount += 1
			change_enemy_label()
		elif bodyTeam == Team.TeamName.PLAYER:
			playerCount += 1
			change_player_label()

		check_base_team()


func _on_Base_body_exited(body):
	if body.has_method("get_team"):
		var bodyTeam = body.get_team()
		if bodyTeam == Team.TeamName.ENEMY:
			enemyCount -= 1
			change_enemy_label()
		elif bodyTeam == Team.TeamName.PLAYER:
			playerCount -= 1
			change_player_label()

		check_base_team()

func change_player_label():
	playerLabel.text = str(playerCount)


func change_enemy_label():
	enemyLabel.text = str(enemyCount)


#function that will check whcih team capture the base
func check_base_team():
	var majoryTeam = get_team()
	if majoryTeam == Team.TeamName.NEUTRAL:
		return
	elif majoryTeam == team.team:
		print("Capture stop")
		teamToCapture = Team.TeamName.NEUTRAL
		captureTimer.stop()
		
	else:
		print("Capture start")
		teamToCapture = majoryTeam
		captureTimer.start()
		
		

#Function that will decide which team is holding base
func get_team():
	if enemyCount == playerCount:
		return Team.TeamName.NEUTRAL
		
	elif enemyCount > playerCount:
		return Team.TeamName.ENEMY
		
	else:
		return Team.TeamName.PLAYER

#function that will change color for the base
func set_team(newTeam):
	team.team = newTeam
	emit_signal("base_capture", newTeam)
	match newTeam:
		Team.TeamName.NEUTRAL:
			sprite.modulate = neutral_color
			return
		Team.TeamName.PLAYER:
			sprite.modulate = player_color
			return
		Team.TeamName.ENEMY:
			sprite.modulate = enemy_color
			return


func _on_CaptureTimer_timeout():
	set_team(teamToCapture)
