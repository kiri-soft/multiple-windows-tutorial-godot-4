extends Line2D

var points2 = []
var velocities = []
var gravity = Vector2(0, 98)  # Simulating gravity in pixels/second^2
var spring_constant = 200  # Higher value means stiffer "hair"
var damping = 0.9  # Controls how much motion slows down

func _ready():
	# Initialize points and velocities
	points2 = [
		Vector2(0, 0),
		Vector2(10, 30),
		Vector2(20, 60),
		Vector2(30, 90)
	]
	
	
	for i in range(points2.size()):
		velocities.append(Vector2(0,0))
	
	
	set_physics_process(true)

func _physics_process(delta):
	apply_gravity(delta)
	apply_spring_forces(delta)
	apply_damping()
	
	update_line()

# Apply gravity to each point (except the root point if it's fixed)
func apply_gravity(delta):
	for i in range(1, points2.size()):  # Skip the first point (root)
		velocities[i] += gravity * delta
		points2[i] += velocities[i] * delta

# Apply spring forces between consecutive points to simulate hair flexibility
func apply_spring_forces(delta):
	for i in range(1, points2.size()):
		var direction = points2[i] - points2[i - 1]
		var distance = direction.length()
		var rest_length = 30  # Rest length of the "hair strand"
		
		if distance > rest_length:
			var force = spring_constant * (distance - rest_length)
			direction = direction.normalized()
			
			# Apply the force to move points back towards rest position
			velocities[i] -= direction * force * delta
			points2[i] += direction * force * delta * 0.5

# Apply damping to slow down motion over time
func apply_damping():
	for i in range(1, velocities.size()):
		velocities[i] *= damping

# Update the Line2D node's points
func update_line():
	clear_points()
	for point in points2:
		add_point(point)
