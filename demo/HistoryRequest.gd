extends NanoRequest

const node_credentials = preload("credentials.gd")

func _ready():
	var auth = basic_auth_header(node_credentials.username, node_credentials.password)
	set_connection_parameters("https://madora.io/api/rpc", auth)

	account_history()

func account_history():
	var body = {
		"action": "account_history",
		"account": global.account.get_address(),
		"count": 10
	}
	var err = nano_request(body)
	if(err):
		print("Account history failed " + str(err))

func _on_HistoryRequest_request_completed(result, response_code, headers, body):
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
	
	var history = response.result["history"]
	if(!history):
		$"../Default/ItemList".add_item("No transactions.")
		return
		
	for block in history:
		var account = block["account"]
		var amount = NanoAmount.new()
		amount.set_amount(block["amount"])
		var type = block["type"]
		var block_hash = block["hash"]
		var message = """Type: {0}\n
		Amount: {1}\n
		Account: {2}\n
		Hash: {3}""".format([type, amount.get_friendly_amount(), account, block_hash])
		
		$"../Default/ItemList".add_item(message)
