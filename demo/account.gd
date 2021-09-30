extends Control

const node_credentials = preload("credentials.gd")
var account: NanoAccount = global.account

var qr: Sprite = null

func _ready():
	$"Default/InfoLabel".text = """Current Balance: ???\n
	Address: {0}
	""".format([account.get_address()])
	
	var default_rep = NanoAccount.new()
	default_rep.set_address("nano_3g6ue89jij6bxaz3hodne1c7gzgw77xawpdz4p38siu145u3u17c46or4jeu")
	
	var auth = $"BalanceRequest".basic_auth_header(node_credentials.username, node_credentials.password)
	var err = $"NanoWatcher".initialize_and_connect("wss://madora.io/api/websocket", 
		default_rep, "https://madora.io/api/rpc", auth, true, "", true)
	if(err):
		print("Websocket not connected: Auto receives and send/receive auto-updates will not process.")
		
	$"NanoWatcher".add_watched_account(account)

func set_balance(amount: NanoAmount):
	$"Default/InfoLabel".text = """Current Balance: {0}\n
	Address: {1}
	""".format([amount.get_friendly_amount(), account.get_address()])

func _on_BackupSeed_pressed():
	$"BackupSeedView/SeedLabel".text = "Seed: " + account.get_seed()
	$"Default".visible = false
	$"BackupSeedView".visible = true

func _on_BackButton_pressed():
	$"Default".visible = true
	$"ReceiveView".visible = false
	$"BackupSeedView".visible = false	
	$"SendView".visible = false

func _on_CopyButton_pressed():
	OS.set_clipboard(account.get_seed())

func _on_ReceiveButton_pressed():
	$"ReceiveView/AccountLabel".text = account.address
	
	if(!qr):
		var qr_sprite = account.get_qr_code()
		qr = Sprite.new()
		$"ReceiveView".add_child(qr)
		qr.set_texture(qr_sprite)
	qr.position = get_viewport_rect().size / 2
	qr.scale = Vector2(9, 9)
	
	$"Default".visible = false
	$"ReceiveView".visible = true

func _on_NanoWatcher_nano_receive_completed(account, message, response_code):
	if(response_code):
		print("Failed to receive automatically: " + message)
		print("Attempting manual receive...")
		$"PendingRequest".pending(0, "1")
	else:
		$"BalanceRequest".account_balance()
		$"HistoryRequest".account_history()

func _on_SendButton_pressed():
	$"Default".visible = false
	$"SendView".visible = true

func _on_SendConfirmButton_pressed():
	var dest = NanoAccount.new()
	var error = dest.set_address($"SendView/AddressLabel".text)
	if(error):
		$"SendView/ErrorLabel".text = "Invalid Address"
		return
	var amount = NanoAmount.new()
	error = amount.set_nano_amount($"SendView/AmountLabel".text)
	if (error):
		$"SendView/ErrorLabel".text = "Invalid Amount"
		return
	$"NanoSender".send(account, dest, amount)
	$"SendView/ErrorLabel".text = amount.get_nano_amount() + " sent to " + dest.get_address()
	$"SendView/SendButton".visible = false

func _on_NanoWatcher_confirmation_received(json):
	$"BalanceRequest".account_balance()
	$"HistoryRequest".account_history()

func _on_NanoWatcher_disconnected(was_clean):
	print("Watcher was disconnected. Was clean = " + str(was_clean))
