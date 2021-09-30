extends NanoRequest

const node_credentials = preload("credentials.gd")

func _ready():
	var auth = basic_auth_header(node_credentials.username, node_credentials.password)
	set_connection_parameters("https://madora.io/api/rpc", auth)
	set_account(global.account)

	var err = account_balance()
	if(err):
		print("Account balance failed " + str(err))

func _on_BalanceRequest_request_completed(result, response_code, headers, body):
	var str_body = body.get_string_from_utf8()
	if(result != OK):
		print("Nano request failed to send: " + str(result))
		return
	if(response_code != 200):
		print("Nano request returned bad response: " + str(result))
		return
		
	var response = JSON.parse(str_body)
	if(response.error):
		print("Failed to parse response for balance request: " + str_body)
		print("Failure reason was: " + response.error_string + " on line " + str(response.error_line))
		return
	
	var balance_response: Dictionary = response.result
	var balance_string: String = balance_response["balance"]
	if(!balance_string):
		print("Could not find balance in response. Maybe account doesn't exist? Response: " + body)
		balance_string = "0"
	else:
		var pending_string = balance_response["pending"]
		if(!pending_string.empty() && pending_string != ""):
			$"../PendingRequest".pending(0, "1")
	
	var amount = NanoAmount.new()
	amount.set_amount(balance_string)
	get_parent().set_balance(amount)
