extends NanoReceiver

var pending_blocks: Dictionary = {}
var default_rep: NanoAccount

const node_credentials = preload("credentials.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	default_rep = NanoAccount.new()
	default_rep.set_address("nano_3g6ue89jij6bxaz3hodne1c7gzgw77xawpdz4p38siu145u3u17c46or4jeu")
	
	var auth: String = $"../BalanceRequest".basic_auth_header(node_credentials.username, node_credentials.password)
	set_connection_parameters("https://madora.io/api/rpc", default_rep, auth, true, "", true)

func add_pending_blocks(blocks: Dictionary):
	for key in blocks.keys():
		if(pending_blocks.get(key) == null):
			pending_blocks[key] = blocks[key]
	if(is_ready()):
		var block_hash = pending_blocks.keys()[0]
		var block_amount = pending_blocks[block_hash]
		var nano_amount: NanoAmount = NanoAmount.new()
		nano_amount.set_amount(block_amount)

		receive(global.account, block_hash, nano_amount)
		pending_blocks.erase(block_hash)

func _on_NanoReceiver_nano_receive_completed(account, message, response_code):
	if(response_code):
		print("Recieve failed: " + message)
		if(pending_blocks.size() > 0):
			print("Pending blocks remaining will not be processed: " + str(pending_blocks.size()))
	else:
		if(pending_blocks.size() > 0):
			var block_hash = pending_blocks.keys()[0]
			var block_amount = pending_blocks[block_hash]
			var nano_amount: NanoAmount = NanoAmount.new()
			nano_amount.set_amount(block_amount)

			receive(global.account, block_hash, nano_amount)
			pending_blocks.erase(block_hash)
