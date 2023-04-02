extends Node2D
#This script is for the AI to capture bases and respawn

enum BaseCaptureOrder {
	FIRST,
	LAST
}


export (BaseCaptureOrder) var base_Capture_Start_Order
export (Team.TeamName) var team_name = Team.TeamName.NEUTRAL
export (PackedScene) var unit = null
export var max_unit_alive = 16


onready var team = $Team
onready var unitContainer = $UnitContainer
onready var respawnTimer = $RespawnTimer

#Part for AI to looking for the base
var targetBase = null
var captureBases = []
var respawnPoints = []
var nextSpawnToUse = 0
var pathfinding: Pathfinding



func initialize(captureBases, respawnPoints, pathfinding):
	if captureBases.size() == 0 or respawnPoints.size() == 0 or unit == null:
		push_error("Map AI")
		return
		
		
	team.team = team_name
	
	self.pathfinding = pathfinding
	#Spawn the max unit amount of units at the beginning
	#Add those units to the unit container
	self.respawnPoints = respawnPoints
	for respawn in respawnPoints:
		spawn_unit(respawn.global_position)
	
	
	self.captureBases = captureBases

	for base in captureBases:
		base.connect("base_capture", self, "handle_base_capture")

	checkForCaptureBase()

func handle_base_capture(newTeam):
	checkForCaptureBase()


func checkForCaptureBase():
	var nextBase = getNextBase()
	if nextBase != null:
		targetBase = nextBase
		assignNextBase(nextBase)


#function that assume base capture start order is first
func getNextBase():
	var listOfBases = range(captureBases.size()) 
	if base_Capture_Start_Order == BaseCaptureOrder.LAST:
		listOfBases = range(captureBases.size() - 1, -1, -1)
	
	for i in listOfBases:
		var base = captureBases[i]
		if team.team != base.team.team:
			print("Team %d tp capture base %d" % [team.team, i])
			return base
			
	return null


func assignNextBase(base):
	
	for unit in unitContainer.get_children():
			
		set_unit_to_next_base(unit)

func spawn_unit(spawnLocation):
	var unit_instance = unit.instance()
	unitContainer.add_child(unit_instance)
	unit_instance.global_position = spawnLocation
	unit_instance.connect("died", self, "handle_unit_death")
	unit_instance.ai.pathfinding = pathfinding
	set_unit_to_next_base(unit_instance)


func set_unit_to_next_base(unit):
	if targetBase != null:
	
		var ai: AI = unit.ai
		ai.nextBase = targetBase.get_random_position_capture()
		ai.setState(AI.State.ADVANCE)


func handle_unit_death():
	if respawnTimer.is_stopped() and unitContainer.get_children().size() < max_unit_alive:
		respawnTimer.start()



func _on_RespawnTimer_timeout():
	var respawn = respawnPoints[nextSpawnToUse]
	spawn_unit(respawn.global_position)
	nextSpawnToUse += 1
	if nextSpawnToUse == respawnPoints.size():
		nextSpawnToUse = 0
	
	
	if unitContainer.get_children().size() < max_unit_alive:
		respawnTimer.start()
