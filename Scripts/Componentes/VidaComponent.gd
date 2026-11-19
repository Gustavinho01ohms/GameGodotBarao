
extends Node

class_name VidaComponent

signal vida_alterada(valor: int)

@export var vida_maxima: int = 100

var vida_atual: int


func _ready() -> void:
	vida_atual = vida_maxima


func receber_dano(quantidade: int) -> void:
	if vida_atual <= 0:
		return

	vida_atual -= quantidade
	vida_atual = max(vida_atual, 0)

	print("Vida atual: ", vida_atual)

	vida_alterada.emit(vida_atual)
