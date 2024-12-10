extends Control

var win_level1 := false
var win_level2 := false
var win_level3 := false
var win_level4 := false

@onready var level_1_btn: TextureButton = $Panel2/VBoxContainer/Level1Container/Level1
@onready var level_2_btn: TextureButton = $Panel2/VBoxContainer/Level2Container/Level2
@onready var level_3_btn: TextureButton = $Panel2/VBoxContainer/Level3Container/Level3
@onready var level_4_btn: TextureButton = $Panel2/VBoxContainer/Level4Container/Level4
@onready var texture_rect1: TextureRect = $Panel2/VBoxContainer/Level1Container/TextureRect
@onready var texture_rect2: TextureRect = $Panel2/VBoxContainer/Level2Container/TextureRect
@onready var texture_rect3: TextureRect = $Panel2/VBoxContainer/Level3Container/TextureRect
@onready var texture_rect4: TextureRect = $Panel2/VBoxContainer/Level4Container/TextureRect
@onready var level_1: Control = $LevelPanel/Level1
@onready var level_2: Control = $LevelPanel/Level2
@onready var level_3: Control = $LevelPanel/Level3
@onready var level_4: Control = $LevelPanel/Level4


func _ready():
	level_1.win.connect(func(): 
		win_level1=true
		texture_rect1.visible = true
		check_win()
		)
	level_2.win.connect(func(): 
		win_level2=true
		texture_rect2.visible = true
		check_win()
		)
	level_3.win.connect(func(): 
		win_level3=true
		texture_rect3.visible = true
		check_win()
		)
	level_4.win.connect(func(): 
		win_level4=true
		texture_rect4.visible = true
		check_win()
		)
	hide_levels()


func _on_level_1_pressed() -> void:
	hide_levels()
	level_1.visible = true


func _on_level_2_pressed() -> void:
	hide_levels()
	print(1)
	level_2.visible = true


func _on_level_3_pressed() -> void:
	hide_levels()
	level_3.visible = true


func _on_level_4_pressed() -> void:
	hide_levels()
	level_4.visible = true

func hide_levels() -> void:
	level_1.visible = false
	level_2.visible = false
	level_3.visible = false
	level_4.visible = false
	
func check_win() -> void:
	if win_level1 && win_level2 && win_level3 && win_level4:
		get_tree().change_scene_to_file("res://ui/vitoria.tscn")
