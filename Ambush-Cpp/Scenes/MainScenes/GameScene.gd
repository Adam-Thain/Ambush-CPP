extends Node2D

signal game_finished(result)

var map_node
var build_mode = false
var build_valid = false
var build_tile
var build_location
var build_type

var current_wave = 0
var enemies_remaining= 0
var wave_spawned = false

var base_health = 100

func _ready():
	map_node = get_node("Map1")
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed",initiate_build_mode.bind(i.get_name()))
	
func _process(_delta):
	if build_mode:
		update_tower_preview()
	
func _unhandled_input(_event):
	if _event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if _event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

##
##	Wave Functions
##
func start_next_wave():
	var wave_data = retrieve_wave_data()
	await get_tree().create_timer(0.2).timeout
	spawn_enemies(wave_data)

func retrieve_wave_data():
	var wave_data = GameData.wave_data[current_wave]["wave"]
	enemies_remaining = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	wave_spawned = true
	
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		new_enemy.connect("damage_base", Callable(self, "on_base_damage"))
		new_enemy.connect("destroyed", Callable(self, "on_enemy_destroyed"))
		new_enemy.type = i[0]
		map_node.get_node("Path").add_child(new_enemy, true)
		await(get_tree().create_timer(i[1]).timeout)

##
##	Building Functions
##
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	if(GameData.tower_data[tower_type]["cost"] > GameData.player_data["Money"]):
		return
	build_type = tower_type
	build_mode = true
	get_node("UI").set_tower_preview(build_type,get_global_mouse_position())
	
func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("TowerExclusion").local_to_map(mouse_position)
	var tile_position = map_node.get_node("TowerExclusion").map_to_local(current_tile)
	
	if map_node.get_node("TowerExclusion").get_cell_source_id(0,current_tile) == -1:
		get_node("UI").update_tower_preview(tile_position,"00ff00")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else: 
		get_node("UI").update_tower_preview(tile_position,"ff0000")
		build_valid = false
	
func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").queue_free()
	
func verify_and_build():
	if build_valid:
		var new_tower = load("res://Scenes/Turrets/" + build_type + ".tscn").instantiate()
		new_tower.position = build_location
		new_tower.built = true
		new_tower.type = build_type
		new_tower.category = GameData.tower_data[build_type]["category"]
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cell(0,build_tile,1,Vector2i(1,0))
		get_node("UI").subtract_money(GameData.tower_data[build_type]["cost"], new_tower.position)

func on_base_damage(damage):
	base_health -= damage
	if base_health <= 0:
		emit_signal("game_finished", false)
	else: 
		get_node("UI").update_health_bar(base_health)

func on_enemy_destroyed(money,pos):
	if enemies_remaining > 0:
		enemies_remaining -= 1
		get_node("UI").add_money(money,pos)
		if(enemies_remaining <= 0 && wave_spawned):
			get_node("UI").wave_complete()
