extends CharacterBody2D

const SPEED = 200.0

@onready var anim = $AnimatedSprite2D 

func _physics_process(_delta):
	# O get_vector faz todo o cálculo de diagonais automaticamente
	var direction = Input.get_vector("mover_esquerda", "mover_direita", "mover_cima", "mover_baixo")
	
	velocity = direction * SPEED
	
	if direction == Vector2.ZERO:
		anim.play("idle")
	else:
		if abs(direction.x) > abs(direction.y):
			anim.play("walk_side")
			anim.flip_h = direction.x < 0
		elif direction.y > 0:
			anim.play("walk_down")
		elif direction.y < 0:
			anim.play("walk_up")

	move_and_slide()
