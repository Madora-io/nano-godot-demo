tool
extends EditorPlugin


func _enter_tree():
	preload("res://addons/nano-godot/nano_rpc.gd")
	preload("res://addons/nano-godot/nano_rpc_actions.gd")
	pass


func _exit_tree():
	pass
