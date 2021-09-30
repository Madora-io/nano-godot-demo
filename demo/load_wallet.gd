extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	var check_file = File.new()
	if not check_file.file_exists("user://account.save"):
		get_tree().change_scene("res://demo/new_wallet.tscn")

func _on_Button_pressed():
	var file = File.new()
	var password = $"Password".text
	var err = file.open_encrypted_with_pass("user://account.save", File.READ, password)
	if(err):
		$"ErrorLabel".visible = true
		return
	
	var nano_seed = file.get_as_text().strip_edges()
	var account = NanoAccount.new()
	account.set_seed(nano_seed)
	global.account = account
	get_tree().change_scene("res://demo/account.tscn")
