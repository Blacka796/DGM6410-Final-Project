extends Node2D
class_name AI

#This script is for Enemy and Ally's AI
#Set enemy's behavior in here
signal stateChanged(newState)


onready var patrolTimer = $PatrolTimer


enum State{
	PATROL,
	ENGAGE,
	ADVANCE
}

#Set the state and identity the player, use the weapon
var currentState: int = -1 setget setState
var actor: Actor = null
var target: KinematicBody2D = null
var weapon: Weapon = null
var team: int = -1


#Advance state for AI
var nextBase = Vector2.ZERO

var pathfinding: Pathfinding


#Set the patrol location and velocity for the enemy
var origin: Vector2 = Vector2.ZERO
var patrolLocation: Vector2 = Vector2.ZERO
var patrolLocationReach: bool = false
var actorVelocity: Vector2 = Vector2.ZERO


func _ready():
	setState(State.PATROL)
	

func _physics_process(delta):
	match currentState:
		State.PATROL:
			if not patrolLocationReach:
				var path = pathfinding.get_new_path(global_position, patrolLocation)
				
				if path.size() > 1:
					actorVelocity = actor.velocity_toward(path[1])
					actor.rotate_toward(path[1])
					actor.move_and_slide(actorVelocity)
					
					
				else:

					patrolLocationReach = true
					actorVelocity = Vector2.ZERO
					patrolTimer.start()
				
		State.ENGAGE:
			if target != null and weapon != null:
				actor.rotate_toward(target.global_position)
				var angleToTarget = actor.global_position.direction_to(target.global_position).angle()
				if abs(actor.rotation - angleToTarget) < 0.1:
					weapon.shoot()
			else:
				print("In the engage")
		
		State.ADVANCE:
			var path = pathfinding.get_new_path(global_position, nextBase)
			if path.size() > 1:
				actorVelocity = actor.velocity_toward(path[1])
				actor.rotate_toward(path[1])
				actor.move_and_slide(actorVelocity)
			else:
				setState(State.PATROL)
		
		
		_:
			print("Error")



func initialize(actor: KinematicBody2D, weapon: Weapon, team: int):
	self.weapon = weapon
	self.actor = actor
	self.team = team
	
	weapon.connect("weaponOutOfAmmo", self, "handle_reload")

#Function that set each state will do
func setState(newState):
	if newState == currentState:
		return
	
	if newState == State.PATROL:
		origin = global_position
		patrolTimer.start()
		patrolLocationReach = true
		
	elif newState == State.ADVANCE:
		if actor.has_reached_position(nextBase):
			setState(State.PATROL)
		
	
	currentState = newState
	emit_signal("stateChanged", currentState)


func handle_reload():
	weapon.start_reload()



func _on_PatrolTimer_timeout():

	var patrolRange = 260
	var randomX = rand_range(-patrolRange, patrolRange)
	var randomY = rand_range(-patrolRange, patrolRange)
	patrolLocation = Vector2(randomX, randomY) + origin
	patrolLocationReach = false
	



func _on_Detection_body_entered(body):
	if body.has_method("get_team") and body.get_team() != team:
		setState(State.ENGAGE)
		target = body


func _on_Detection_body_exited(body):
	if target and body == target:
		setState(State.ADVANCE)
		target = null
