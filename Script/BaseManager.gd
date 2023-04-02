extends Node2D


signal player_get_all_bases
signal player_lose_all_bases


var bases = []


func _ready():
	bases = get_children()
	for base in bases:
		base.connect("base_capture", self, "handle_base")


func getCaptureBases():
	return bases


func handle_base(_team):
	var playerBases = 0
	var enemyBases = 0
	var totalBases = bases.size()
	
	for base in bases:
		match base.team.team:
			Team.TeamName.PLAYER:
				playerBases += 1
			Team.TeamName.ENEMY:
				enemyBases += 1
			Team.TeamName.NEUTRAL:
				return

	if playerBases == totalBases:
		emit_signal("player_get_all_bases")
	elif enemyBases == totalBases:
		emit_signal("player_lose_all_bases")
	

