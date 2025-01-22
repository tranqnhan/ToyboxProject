extends Control

signal finished


var alphabet = {
"0" : preload("res://Scenes/LetterTrace/number_0.tscn"),
"1" : preload("res://Scenes/LetterTrace/number_1.tscn"),
"2" : preload("res://Scenes/LetterTrace/number_2.tscn"),
"3" : preload("res://Scenes/LetterTrace/number_3.tscn"),
"4" : preload("res://Scenes/LetterTrace/number_4.tscn"),
"5" : preload("res://Scenes/LetterTrace/number_5.tscn"),
"6" : preload("res://Scenes/LetterTrace/number_6.tscn"),
"7" : preload("res://Scenes/LetterTrace/number_7.tscn"),
"8" : preload("res://Scenes/LetterTrace/number_8.tscn"),
"9" : preload("res://Scenes/LetterTrace/number_9.tscn"),
"=" : preload("res://Scenes/LetterTrace/equal_sign.tscn"),
"×" : preload("res://Scenes/LetterTrace/operator_multiply.tscn"),
"+" : preload("res://Scenes/LetterTrace/operator_add.tscn"),
"-" : preload("res://Scenes/LetterTrace/operator_subtract.tscn"),
"÷" : preload("res://Scenes/LetterTrace/operator_divide.tscn")
}

var spacing: int
var letters: Array = []
var current_letter: int = 0
var init_letter: bool = false
var complete: bool = false


func _ready() -> void:
	spacing = $Letters.get_theme_constant("separation")
	#generate_letters("1+1=2")
	

func generate_letters(text):
	clear()
	complete = false
	current_letter = 0
	for letter in text:
		if alphabet.has(letter):
			var letter_trace = alphabet[letter].instantiate()
			$Letters.add_child(letter_trace)
	
	letters = $Letters.get_children()
	letters[current_letter].activate()
	init_letter = true


	
func clear():
	for p in $Letters.get_children():
		$Letters.remove_child(p)
		p.queue_free()
	letters.clear()
	init_letter = false
	complete = false


func _process(_delta) -> void:
	if complete or not init_letter:
		return
		
	if len(letters) > 0 and not letters[current_letter].activated:
		current_letter += 1
		if current_letter < len(letters):
			letters[current_letter].activate()
		else:
			complete = true
			finished.emit()


func _on_letters_sort_children() -> void:
	for n in $Letters.get_children():
		n.real_position = n.global_position
