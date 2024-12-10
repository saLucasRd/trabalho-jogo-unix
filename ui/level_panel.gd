extends Panel

@onready var level_manager = preload("res://ui/level_manager.gd").new()

# Associe cada botão de nível à função
func _ready():
	$VBoxContainer.Level1Container.Level1.connect("pressed", self, "_on_level_button_pressed", [1])
	$VBoxContainer.Level2Container.Level2.connect("pressed", self, "_on_level_button_pressed", [2])
	# Continue para os demais botões...

# Lógica ao clicar em um botão
func _on_level_button_pressed(level_id):
	print("Nível selecionado: ", level_id)
	level_manager.start_level(level_id)
