extends Node

# Autoload Set Data Manager

var problems: Dictionary = {}
var user_coins: int = 0


func _init() -> void:
	# Load data from json
	print("Loading set data from json")
	# problems
	# user_coins
	pass


func get_problem(problem_key: String) -> Problem:
	return problems[problem_key]

	
func problem_exists(problem_key: String) -> bool:
	return problems.has(problem_key)


func set_problem(problem_key: String, problem: Problem) -> void:
	problems[problem_key] = problem


func add_to_user_coins(coins: int) -> void:
	print(coins, " coins deposited successfully. Remaining coins: ", user_coins, ".")
	user_coins += coins


# Returns the amount of coins subtracted from the total coins
# If the amount of coins subtracted from the total coins is zero,
# that means the total coins is smaller than the amount of coins required.
func subtract_from_user_coins(coins: int) -> int:
	if coins > user_coins:
		print("Insufficient funds, required ", coins, " coins. Remaining coins: ", user_coins, ".")
		return 0
	print(coins, " coins exchanged successfully. Remaining coins: ", user_coins, ".")
	user_coins -= coins
	return coins


func read_user_coins() -> int:
	print(user_coins, " coins retrieved successfully.")
	return user_coins
