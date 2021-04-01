class_name NanoRpc
extends Node

signal nano_response

export(String) var nano_node_username
export(String) var nano_node_password
export(String) var nano_node_url
export(bool) var use_ssl = true

var basic_auth_header: String

var http_request: HTTPRequest

class NanoRequest:
	var action: String

class NanoResponse:
	var response_code: int
	var result: Dictionary

func _init() -> void:
	if nano_node_username and nano_node_password:
		var b64_encoded = Marshalls.utf8_to_base64(nano_node_username + ":" + nano_node_password)
		basic_auth_header = "Authorization: Basic " + b64_encoded
	
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")

func rpc_call(request: NanoRequest) -> void:
	var data = JSON.print(request)
	var headers = []
	if basic_auth_header:
		headers.append(basic_auth_header)
	http_request.request(nano_node_url, headers, use_ssl, HTTPClient.METHOD_POST, data)

func _on_request_completed(result, response_code, headers, body):
	var decoded_result: Dictionary
	if response_code == 200:
		decoded_result = JSON.parse(body).get_result()
	
	var r = NanoResponse.new()
	r.result = decoded_result
	r.response_code = response_code
	
	emit_signal("nano_response", r)
