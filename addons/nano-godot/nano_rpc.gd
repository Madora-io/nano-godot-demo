class_name NanoRpc
extends Node

signal nano_response

export(String) var nano_node_url
export(bool) var use_ssl = true

var auth_header: String

var http_request: HTTPRequest

class NanoResponse:
	var response_code: int
	var result: Dictionary

func _init(url) -> void:
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")
	nano_node_url = url
	
func set_basic_auth(username: String, password: String) -> void:
	var b64_encoded = Marshalls.utf8_to_base64(username + ":" + password)
	auth_header = "Authorization: Basic " + b64_encoded

func set_authorization_header(header: String) -> void:
		auth_header = "Authorization: " + header

func rpc_call(request: Dictionary) -> void:
	assert(nano_node_url != null and nano_node_url.length() > 0)

	var data = JSON.print(request)
	print(data)
	var headers = []
	if auth_header:
		print("Adding auth header: " + auth_header)
		headers.append(auth_header)
	var error = http_request.request(nano_node_url, headers, use_ssl, HTTPClient.METHOD_POST, data)
	if error != OK:
		push_error("An error occurred in the http_request.")

func _on_request_completed(result, response_code, headers, body):
	var decoded_result: Dictionary

	decoded_result = JSON.parse(body.get_string_from_utf8()).get_result()

	var r = NanoResponse.new()
	r.result = decoded_result
	r.response_code = response_code
	
	emit_signal("nano_response", r)
