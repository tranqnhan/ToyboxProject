extends PracticeSet
class_name AddBySet


func _init(by_num: int) -> void:
	set_name = "Add by " + str(by_num)
	var problem_name: String
	for i in range(1, 11, 1):
		var problem: Problem
		problem_name = str(by_num) + "+" + str(i) + "="
		if !SetDataManager.problem_exists(problem_name): 
			var problem_answer: String = str(by_num + i)
			problem = Problem.new(problem_name, problem_answer, 0, 0)
			SetDataManager.set_problem(problem_name, problem)
		else:
			problem = SetDataManager.get_problem(problem_name)
			
		problems.append(problem)
