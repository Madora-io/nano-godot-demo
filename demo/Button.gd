extends Button

var rpc
var request

func _ready():
	rpc = NanoRpc.new("https://mynano.ninja/api/node")
	add_child(rpc)
	rpc.set_authorization_header("<insert token here>")
	request = {"action": "telemetry"}
	rpc.connect("nano_response", self, "_on_rpc_response")
	
func _pressed():
	rpc.rpc_call(request)

func _on_rpc_response(response: NanoRpc.NanoResponse):
	print("Response: " + str(response.response_code))
	print(response.result)
