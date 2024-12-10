extends Control

var win_level1 := false
var win_level2 := false
var win_level3 := false
var win_level4 := false

@onready var level_1: TextureButton = $Panel2/VBoxContainer/Level1Container/Level1
@onready var level_2: TextureButton = $Panel2/VBoxContainer/Level2Container/Level2
@onready var level_3: TextureButton = $Panel2/VBoxContainer/Level3Container/Level3
@onready var level_4: TextureButton = $Panel2/VBoxContainer/Level4Container/Level4
@onready var texture_rect1: TextureRect = $Panel2/VBoxContainer/Level1Container/TextureRect
@onready var texture_rect2: TextureRect = $Panel2/VBoxContainer/Level2Container/TextureRect
@onready var texture_rect3: TextureRect = $Panel2/VBoxContainer/Level3Container/TextureRect
@onready var texture_rect4: TextureRect = $Panel2/VBoxContainer/Level4Container/TextureRect


func _ready():
	level_1.
	hide_levels()


func _on_level_1_pressed() -> void:
	hide_levels()
	level_1.visible = true


func _on_level_2_pressed() -> void:
	hide_levels()
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
