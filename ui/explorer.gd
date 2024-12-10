extends Control

#@export var levels: Array[Node] # Array contendo os nós dos níveis
@onready var level_panels = $LevelPanel.get_children() # Pega os painéis filhos do LevelPanel

# Função auxiliar para alternar a visibilidade de um nó
func _toggle_visibility(node: Node) -> void:
	node.visible = not node.visible

# Oculta todos os níveis
func hide_all_levels() -> void:
	for level_panel in level_panels:
		level_panel.visible = false

# Função genérica para lidar com a seleção de níveis
func on_level_pressed(level_index: int) -> void:
	hide_all_levels() # Oculta todos os níveis antes de mostrar o selecionado
	if level_index >= 0 and level_index < level_panels.size():
		print("Nível selecionado:", level_index + 1)
		_toggle_visibility(level_panels[level_index])

# Vincula automaticamente os botões de nível às funções
func _ready():
	for i in range(level_panels.size()):
		var button = level_panels[i].get_node("Button") 
		#if button:
			#button.connect("pressed", self, "on_level_pressed", [i])
