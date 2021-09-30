extends Control

func _on_Button_pressed():
	var account = NanoAccount.new()
	account.initialize_with_new_seed()
	global.account = account
	
	var password = $"Password".text
	var password_verify = $"PasswordVerify".text
	if(password != password_verify):
		$"Label4".visible = true
		return
	
	var save_account = File.new()
	save_account.open_encrypted_with_pass("user://account.save", File.WRITE, password)
	save_account.store_line(account.get_seed())
	
	get_tree().change_scene("res://demo/account.tscn")
