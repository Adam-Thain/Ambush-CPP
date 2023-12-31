extends Node2D

var type
var category
var enemy_array = []
var built = false
var enemy
var ready_to_fire = true

func _ready():
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]

func _physics_process(_delta):
	if enemy_array.size() != 0 && built:
		select_enemy()
		if not get_node("AnimationPlayer").is_playing():
			turn()
		if ready_to_fire:
			fire()
	else:
		enemy = null

func turn():
	get_node("Turret").look_at(enemy.position)

func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.get_progress())
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]
	
func fire():
	ready_to_fire = false
	if category == "projectile":
		fire_gun()
	elif category == "missile":
		fire_missile()
	enemy.on_hit(GameData.tower_data[type]["damage"])
	await(get_tree().create_timer(GameData.tower_data[type]["rof"]).timeout)
	ready_to_fire = true
	
func fire_gun():
	get_node("AnimationPlayer").play("Fire")
	
func fire_missile():
	pass

func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())

func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
