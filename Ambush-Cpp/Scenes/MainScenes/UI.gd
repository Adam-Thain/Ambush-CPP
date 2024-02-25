extends CanvasLayer

@onready var hp_bar = get_node("HUD/InfoBar/H/HP")
@onready var money = get_node("HUD/InfoBar/H/Money")
@onready var floating_text = preload("res://Scenes/UIScenes/FloatingText.tscn")

func set_tower_preview(tower_type, mouse_position):
	var drag_tower = load("res://Scenes/Turrets/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("00ff00")
	
	var range_texture = Sprite2D.new()
	range_texture.position = Vector2(0,0)
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling,scaling) 
	var texture = load("res://Assets/UI/range_overlay.png");
	range_texture.texture = texture;
	range_texture.modulate = Color("00ff00")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"),0)

func update_tower_preview(new_position, color):
	get_node("TowerPreview").position = new_position
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/Sprite2D").modulate = Color(color)

##
## Game Control Functions
##
func _on_pause_play_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if get_tree().is_paused():
		get_tree().paused = false
	elif get_parent().wave_spawned == false:
		get_parent().current_wave += 1
		get_parent().start_next_wave()
	else:
		get_tree().paused = true

func _on_speed_up_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(2.0)

func update_health_bar(base_health):
	var hp_bar_tween = get_tree().create_tween()
	hp_bar_tween.set_trans(Tween.TRANS_LINEAR)
	hp_bar_tween.set_ease(Tween.EASE_IN_OUT)
	hp_bar_tween.tween_property(hp_bar,"value",base_health,0.1)
	await hp_bar_tween.finished
	if base_health >= 60:
		hp_bar.set_tint_progress("4eff15")
	elif base_health <= 60 and base_health >= 25:
		hp_bar.set_tint_progress("e1be32")
	else:
		hp_bar.set_tint_progress("e11e1e")

func add_money(amount, position):
	var text = floating_text.instantiate()
	add_child(text)
	text.set_values_and_animate(amount,"Gain",position,50)
	GameData.player_data["Money"] += amount
	money.set_text(str(GameData.player_data["Money"]))

func subtract_money(amount, position):
	var text = floating_text.instantiate()
	add_child(text)
	text.set_values_and_animate(amount,"Spend",position,50)
	GameData.player_data["Money"] -= amount
	money.set_text(str(GameData.player_data["Money"]))

func wave_complete():
	get_parent().wave_spawned = false
