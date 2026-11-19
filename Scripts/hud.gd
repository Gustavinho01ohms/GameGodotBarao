extends CanvasLayer

@onready var vida = $"../Jogador/VidaComponent"
@onready var barra = $Barravida


func _ready() -> void:
	barra.max_value = vida.vida_maxima
	barra.value = vida.vida_atual

	barra.visible = true
	barra.position = Vector2(20, 20)
	barra.size = Vector2(300, 27)

	vida.vida_alterada.connect(atualizar_barra)

	print("HUD carregada!")
	print("Vida inicial: ", barra.value)


func atualizar_barra(valor: int) -> void:
	barra.value = valor
