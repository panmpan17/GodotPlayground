extends Node2D

@export
var reviveDelay := 3.0

@export
var candy : Node2D

@export
var candyStartPosition : Vector2i
@export
var candyEndPosition : Vector2i
@export
var candyGridSpacing : int = 32



func _ready():
	RandomPlaceCandy()


func _process(_delta):
	pass


func _on_snake_head_eat_candy():
	RandomPlaceCandy()


func _on_snake_head_dead():
	DelayRevive()


func RandomPlaceCandy():
	var pos = GetRandomCandyPosition()

	candy.global_position = pos


func GetRandomCandyPosition() -> Vector2:
	var x = RandomRange(candyStartPosition.x, candyEndPosition.x + candyGridSpacing)
	var y = RandomRange(candyStartPosition.y, candyEndPosition.y + candyGridSpacing)
	
	return Vector2(
		(x / candyGridSpacing * candyGridSpacing) + (candyGridSpacing / 2),
		(y / candyGridSpacing * candyGridSpacing) + (candyGridSpacing / 2))


func DelayRevive():
	await get_tree().create_timer(reviveDelay).timeout
	var snakeHead = $SnakeHead
	snakeHead.HandleRevive()
	

func RandomRange(start, end) -> int:
	return start + randi() % (end - start)

