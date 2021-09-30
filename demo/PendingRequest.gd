extends NanoRequest

const node_credentials = preload("credentials.gd")

func _ready():
	var auth = basic_auth_header(node_credentials.username, node_credentials.password)
	set_connection_parameters("https://madora.io/api/rpc", auth)
	set_account(global.account)

func _on_PendingRequest_request_completed(result, response_code, headers, body):
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
	
	var pending_response: Dictionary = response.result
	
	var blocks = pending_response["blocks"]
	if not blocks is Dictionary:
		return
	
	$"../NanoReceiver".add_pending_blocks(blocks)
