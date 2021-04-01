extends Node

func _ready():
	var rpc = NanoRpc.new()
	var request = NanoRpc.NanoRequest.new()
	request.action = "telemetry"
	rpc.connect("nano_response", self, "_on_rpc_response")
	rpc.rpc_call(request)

func _on_rpc_response(response: NanoRpc.NanoResponse):
	print(response.result)
