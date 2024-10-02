extends Node2D

const HAIR_POINTS = 6  # Number of points in the hair
const MAX_DISTANCE = 10  # Maximum allowed distance between points
const GRAVITY = Vector2(0, 100)  # Gravity force applied to each point (e.g., downward)
const CONSTRAINT_ITERATIONS = 5  # Number of times we enforce constraints each frame

var hair_points = []  # List of points representing the current positions of the hair
var previous_points = []  # List of points representing the previous positions of the hair
var head_position = Vector2()  # Position of Madeline's head

func _ready():
	# Initialize hair points and previous points (at the same position)
	for i in range(HAIR_POINTS):
		var point = global_position  # Start all points at Madeline's head position
		hair_points.append(point)
		previous_points.append(point)

func _process(delta):
	update_head_position()
	verlet_integration(delta)
	enforce_constraints()
	queue_redraw()

func update_head_position():
	# Set the first hair point to follow the head position
	head_position = global_position  # Replace with actual head position tracking
	hair_points[0] = head_position

func verlet_integration(delta):
	# Apply Verlet integration to update each point's position
	for i in range(1, HAIR_POINTS):  # Skip the first point (head is fixed)
		var current = hair_points[i]
		var previous = previous_points[i]
		
		# Calculate the velocity as the difference between the current and previous positions
		var velocity = current - previous
		
		# Update the position using Verlet integration
		hair_points[i] = current + velocity + GRAVITY * delta * delta
		
		# Store the current position as the new previous position for the next frame
		previous_points[i] = current

func enforce_constraints():
	# Enforce constraints to maintain the maximum distance between points
	for iteration in range(CONSTRAINT_ITERATIONS):
		for i in range(1, HAIR_POINTS):
			var direction = hair_points[i] - hair_points[i - 1]
			var distance = direction.length()

			if distance > MAX_DISTANCE:
				direction = direction.normalized() * MAX_DISTANCE
				var midpoint = (hair_points[i] + hair_points[i - 1]) / 2

				# Adjust positions of both points to maintain the correct distance
				hair_points[i - 1] = midpoint - direction / 2
				hair_points[i] = midpoint + direction / 2

func _draw():
	# Draw each hair point for visualization purposes
	for i in range(HAIR_POINTS):
		draw_circle(hair_points[i], 5, Color(1, 0, 0))  # Red circles for hair points
