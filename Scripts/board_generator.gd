extends Node

class_name BoardGenerator

# Function to check if a board has a Hamiltonian path starting from 'start'
func is_solvable(board: Array, start: Vector2) -> bool:
	var rows = board.size()
	var cols = board[0].size()
	var total_active = 0
	for row in board:
		total_active += row.count(1)
	
	# Initialize visited matrix
	var visited = []
	for _i in range(rows):
		var row_visited = []
		for _j in range(cols):
			row_visited.append(false)
		visited.append(row_visited)
	
	# Start backtracking from the start position
	return backtrack(board, visited, start, 1, total_active)

# Recursive backtracking function to find a Hamiltonian path
func backtrack(board: Array, visited: Array, pos: Vector2, visited_count: int, total_active: int) -> bool:
	var x = int(pos.x)
	var y = int(pos.y)
	
	# Mark current position as visited
	visited[x][y] = true
	
	# If all active tiles are visited, return true
	if visited_count == total_active:
		return true
	
	# Define possible movement directions (up, down, left, right)
	var directions = [
		Vector2(1, 0),
		Vector2(-1, 0),
		Vector2(0, 1),
		Vector2(0, -1)
	]
	
	# Shuffle directions to introduce randomness
	directions.shuffle()
	
	for dir in directions:
		var nx = x + int(dir.x)
		var ny = y + int(dir.y)
		
		# Check boundaries
		if nx < 0 or nx >= board.size() or ny < 0 or ny >= board[0].size():
			continue
		
		# Check if the next tile is active and not visited
		if board[nx][ny] == 1 and not visited[nx][ny]:
			# Prune paths that cannot possibly reach all tiles
			if can_reach_remaining(board, visited, Vector2(nx, ny), total_active - visited_count):
				if backtrack(board, visited, Vector2(nx, ny), visited_count + 1, total_active):
					return true
	
	# Backtrack: unmark the current position
	visited[x][y] = false
	return false

# Helper function to perform a connectivity check for remaining tiles
func can_reach_remaining(board: Array, visited: Array, start: Vector2, remaining: int) -> bool:
	var rows = board.size()
	var cols = board[0].size()
	var to_visit = [start]
	var local_visited = []
	for _i in range(rows):
		var row_visited = []
		for _j in range(cols):
			row_visited.append(visited[_i][_j])
		local_visited.append(row_visited)
	
	var reachable = 0
	var directions = [
		Vector2(1, 0),
		Vector2(-1, 0),
		Vector2(0, 1),
		Vector2(0, -1)
	]
	
	while to_visit.size() > 0:
		var pos = to_visit.pop_back()
		var x = int(pos.x)
		var y = int(pos.y)
		
		if local_visited[x][y]:
			continue
		
		local_visited[x][y] = true
		reachable += 1
		
		for dir in directions:
			var nx = x + int(dir.x)
			var ny = y + int(dir.y)
			if nx >= 0 and nx < rows and ny >= 0 and ny < cols:
				if board[nx][ny] == 1 and not local_visited[nx][ny]:
					to_visit.append(Vector2(nx, ny))
	
	return reachable >= remaining

# Function to generate a solvable board with given size and number of obstacles
func generate_board(size: int, num_inactive: int) -> Array:
	var attempts = 0
	var max_attempts = 1000  # Prevent infinite loops
	
	while attempts < max_attempts:
		attempts += 1
		
		# 1. Initialize a fully active board
		var board = []
		for i in range(size):
			var row = []
			for j in range(size):
				row.append(1)
			board.append(row)
		
		# 2. Randomly place 'num_inactive' inactive squares
		var inactive_positions = []
		while inactive_positions.size() < num_inactive:
			var pos = Vector2(randi() % size, randi() % size)
			if pos not in inactive_positions:
				inactive_positions.append(pos)
		
		for pos in inactive_positions:
			board[int(pos.x)][int(pos.y)] = 0
		
		# 3. Choose a random starting active square
		var active_positions = []
		for r in range(size):
			for c in range(size):
				if board[r][c] == 1:
					active_positions.append(Vector2(r, c))
		
		if active_positions.size() == 0:
			continue  # No active tiles, retry
		
		var start = active_positions[randi() % active_positions.size()]
		
		# 4. Check if the board is solvable with a Hamiltonian path
		if is_solvable(board, start):
			print("Board generated in", attempts, "attempts")
			return board
		
		# Optional: Print progress every 100 attempts
		if attempts % 100 == 0:
			print("Attempt", attempts, "still searching...")
	
	push_error("Failed to generate a solvable board after", max_attempts, "attempts.")
	return []  # Return an empty array if no solvable board is found

# Example usage
func _ready():
	var generator = BoardGenerator.new()
	var size = 4   # Adjust size as needed (recommend 4 or 5)
	var num_inactive = 2
	var board_model: Array = generator.generate_board(size, num_inactive)
	
	if board_model.size() > 0:
		# Print the board
		for row in board_model:
			print(row)
	else:
		print("No valid board could be generated.")
