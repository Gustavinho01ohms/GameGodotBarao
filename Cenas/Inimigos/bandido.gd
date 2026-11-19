extends CharacterBody2D

# Referência ao jogador
@onready var jogador = get_tree().get_first_node_in_group("jogador")

# Referência às animações
@onready var animacao = $AnimatedSprite2D

# Referência ao componente de vida do jogador
var vida_jogador


# Configurações de movimentação
@export var velocidade: float = 100.0
@export var distancia_deteccao: float = 250.0
@export var distancia_parar: float = 70.0

# Configurações de ataque
@export var distancia_ataque: float = 70.0
@export var dano: int = 20
@export var tempo_entre_ataques: float = 1.5

var pode_atacar: bool = true
var atacando: bool = false

func _ready() -> void:
	if jogador == null:
		print("ERRO: Jogador não encontrado!")
	else:
		vida_jogador = jogador.get_node("VidaComponent")
		print("Jogador encontrado!")

	animacao.play("idle")


func _physics_process(_delta: float) -> void:

	# Verifica se o jogador existe
		# Mantém o Bandido comprometido com o golpe
	if atacando:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Calcula a distância até o jogador
	var distancia = global_position.distance_to(jogador.global_position)

	# Se o jogador estiver longe, fica parado
	if distancia > distancia_deteccao:
		velocity = Vector2.ZERO

		if animacao.animation != "idle":
			animacao.play("idle")

		move_and_slide()
		return

	# Calcula a direção até o jogador
	var direcao = (jogador.global_position - global_position).normalized()

	# Vira o sprite na direção do jogador
	if direcao.x != 0:
		animacao.flip_h = direcao.x < 0

	# Se estiver no alcance de ataque
	if distancia <= distancia_ataque:
		velocity = Vector2.ZERO

		if pode_atacar:
			atacar()
		elif animacao.animation != "attack":
			animacao.play("idle")

		move_and_slide()
		return

	# Se estiver próximo, para
	if distancia <= distancia_parar:
		velocity = Vector2.ZERO

		if animacao.animation != "idle":
			animacao.play("idle")

	else:
		# Persegue o jogador
		velocity = direcao * velocidade

		if animacao.animation != "run":
			animacao.play("run")

	# Executa o movimento
	move_and_slide()


func atacar() -> void:
	if not pode_atacar:
		return

	pode_atacar = false
	atacando = true

	animacao.play("attack")

	# Tempo de preparação do golpe
	await get_tree().create_timer(0.3).timeout

	# Verifica se o jogador ainda está no alcance
	var distancia_atual = global_position.distance_to(jogador.global_position)

	if distancia_atual <= distancia_ataque:
		vida_jogador.receber_dano(dano)

	atacando = false

	# Completa o cooldown
	await get_tree().create_timer(tempo_entre_ataques - 0.3).timeout

	pode_atacar = true
