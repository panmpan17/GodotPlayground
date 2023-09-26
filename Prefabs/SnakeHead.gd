extends Node2D

const UpRotationDegree = 0
const RightRotationDegree = 90
const DownRotationeDegree = 180
const LeftRotationDegree = 270

signal dead

@export
var t : Node2D

@export
var moveSpeed := 5.0

@export
var timeForward := 1.0
var timer = 0

#@export
#var rigidbody2d: RigidBody2D

@export
var bodySpacing  := 32.0

var bodyPrefab : PackedScene


var direction: Vector2 = Vector2(1, 0)
var newDirection : Vector2 = Vector2(1, 0)
var rotationDegree: float = RightRotationDegree

var bodies : Array = []

var isDead : bool = false

var spawnNewBody : bool = false
#var t : Node2D 


func _ready():
	bodyPrefab = preload("res://Prefabs/SnakeBody.tscn")
	
	var newBody = bodyPrefab.instantiate()
	add_child(newBody)
	bodies.append(newBody)
	newBody.global_position.x = global_position.x - bodySpacing


func _process(delta):
	if isDead:
		return

	ListenInput();
	
	timer += delta
	if timer >= timeForward:
		timer = 0
	else:
		return

	if newDirection != direction:
		t.rotation_degrees = rotationDegree
		direction = newDirection

	UpdateBodyPosition();


func ListenInput():
	if Input.is_action_pressed("move_up"):
		if direction != Vector2.DOWN:
			newDirection = Vector2.UP
			rotationDegree = UpRotationDegree
			return

	if Input.is_action_pressed("move_down"):
		if direction != Vector2.UP:
			newDirection = Vector2.DOWN
			rotationDegree = DownRotationeDegree
			return

	if Input.is_action_pressed("move_left"):
		if direction != Vector2.RIGHT:
			newDirection = Vector2.LEFT
			rotationDegree = LeftRotationDegree
			return

	if Input.is_action_pressed("move_right"):
		if direction != Vector2.LEFT:
			newDirection = Vector2.RIGHT
			rotationDegree = RightRotationDegree
			return


func UpdateBodyPosition():
	var lastPositions : Array = [t.global_position]

	for body in bodies:
		lastPositions.append(body.global_position)
	
	t.global_position += (direction * bodySpacing)
	
	for i in bodies.size():
		bodies[i].global_position = lastPositions[i]
	
	if spawnNewBody:
		spawnNewBody = false

		print("Grow")
		var newBody = bodyPrefab.instantiate()
		add_child(newBody)
		bodies.append(newBody)

		newBody.global_position = lastPositions[lastPositions.size() - 1]


func _on_area_2d_body_entered(body):
	if body.is_in_group("Ground"):
		HandleDeath()
		return


func _on_area_2d_area_entered(area):
	if area.is_in_group("Candy"):
		spawnNewBody = true
		return

	if area.is_in_group("Body"):
		HandleDeath()
		return

func HandleDeath():
	isDead = true
	dead.emit()
