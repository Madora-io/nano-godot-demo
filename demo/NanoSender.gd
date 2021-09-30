extends NanoSender

const node_credentials = preload("credentials.gd")

func _ready():
	var auth: String = $"../BalanceRequest".basic_auth_header(node_credentials.username, node_credentials.password)
	set_connection_parameters("https://madora.io/api/rpc", auth, true, "", true)

func _on_NanoSender_nano_send_completed(account, message, response_code):
	if(response_code):
		print("Send failed: " + message)
		$"../SendView/ErrorLabel".text = message
	$"../SendView/SendButton".visible = true
