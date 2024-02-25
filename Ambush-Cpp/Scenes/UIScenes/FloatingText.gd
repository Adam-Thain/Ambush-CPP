extends Node2D

@onready var label = get_node("LabelContainer/Label")
@onready var label_container = get_node("LabelContainer")
@onready var ap = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_values_and_animate(value:int, type:String, start_pos:Vector2, height:float):
	label.set_text("$ " + str(value))
	ap.play("Fade Out")
	match type:
		"Gain":
			label.set("theme_override_colors/font_color",Color("00ff00"))
		"Spend":
			label.set("theme_override_colors/font_color",Color("ff0000"))
	var tween = get_tree().create_tween()
	var end_pos = Vector2(0,-height) + start_pos
	var tween_length = ap.get_animation("Fade Out").length

	tween.tween_property(label_container,"position",end_pos,tween_length).from(start_pos)

func remove():
	ap.stop()
	if is_inside_tree():
		get_parent().remove_child(self)
