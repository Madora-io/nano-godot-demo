extends Node

func _ready():
	var rpc = NanoRpc.new()
	rpc.nano_node_api_key = "CaYewo6tBGVoO2xyUa68W5QAotuYGAhTrwF2jy5xuGzQLt8lkn0iApODy7P33ifb"
	rpc.nano_node_url = "https://mynano.ninja/api/node"
	var request = NanoRpc.NanoRequest.new()
	request.action = "telemetry"
	rpc.connect("nano_response", self, "_on_rpc_response")
	rpc.rpc_call(request)

func _on_rpc_response(response: NanoRpc.NanoResponse):
	print(response.result)
