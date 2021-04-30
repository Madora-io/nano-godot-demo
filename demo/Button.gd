extends Button

var rpc
var request
const credentials = preload("credentials.gd")

func _ready():
	rpc = NanoRpc.new("http://madora.io/api/rpc")
	add_child(rpc)
	rpc.set_basic_auth(credentials.nano_node_username, credentials.nano_node_password)
	request = NanoRpcActions.telemetry
	rpc.connect("nano_response", self, "_on_rpc_response")
	
func _pressed():
	rpc.rpc_call(request)

func _on_rpc_response(response: NanoRpc.NanoResponse):
	print("Response: " + str(response.response_code))
	print(response.result)
