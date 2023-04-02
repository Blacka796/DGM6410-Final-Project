extends CanvasLayer
#This script is for the UI element

onready var healthBar = $MarginContainer/Rows/BottomRow/Health/HealthBar
onready var currentAmmo = $MarginContainer/Rows/BottomRow/Ammo/CurrentAmmo
onready var maxAmmo = $MarginContainer/Rows/BottomRow/Ammo/MaxAmmo
onready var healthTween = $MarginContainer/Rows/BottomRow/Health/HealthTween


var player: Player


func set_player(player: Player):
	self.player = player
	
	set_health_value(player.healthStat.health)
	player.connect("player_health_change", self, "set_health_value")

	set_weapon(player.weaponManager.get_current_weapon())
	player.weaponManager.connect("weaponChanged", self, "set_weapon")


func set_weapon(weapon):
	set_current_ammo(weapon.currentAmmo)
	set_max_ammo(weapon.maxAmmo)
	if not weapon.is_connected("weapon_ammo_change", self, "set_current_ammo"):
		weapon.connect("weapon_ammo_change", self, "set_current_ammo")


func set_health_value(newHealth):
	var originalColor = Color("#67fc14")
	var highlightColor = Color("#2a5d0d")
	
	var barStyle = healthBar.get("custom_styles/fg")
	
	healthTween.interpolate_property(healthBar, "value", healthBar.value, newHealth, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	healthTween.interpolate_property(barStyle, "bg_color", originalColor, highlightColor, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	healthTween.interpolate_property(barStyle, "bg_color", highlightColor, originalColor, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	healthTween.start()
	

func set_current_ammo(newAmmo):
	currentAmmo.text = str(newAmmo)
	
	
func set_max_ammo(new_max_ammo):
	maxAmmo.text = str(new_max_ammo)

