class_name NanoRpcActions
extends Node

func account_balance(account: String):
	return {"action": "account_balance", "account": account}

func account_block_count(account: String):
	return {"action": "account_block_count","account": account}

func account_get(key: String):
	return {"action": "account_get","key": key}

func account_history(account: String, count: int = 1, raw: bool = false, head: String = "", 
	offset: int = 0, reverse: bool = false, account_filter: Array = []):
	var req = {"action": "account_history", "account": account, "count": count}
	if raw: req["raw"] = raw
	if head: req["head"] = head
	if offset: req["offset"] = offset
	if reverse: req["reverse"] = reverse
	if account_filter: req["account_filter"] = account_filter
	return req

func account_info(account: String, representative: bool = false,
	weight: bool = false, pending: bool = false):
	var req = {"action": "account_info", "account": account}
	if representative: req["representative"] = representative
	if weight: req["weight"] = weight
	if pending: req["pending"] = pending
	return req

func account_key(account: String):
	return {"action": "account_key", "account": account}

func account_representative(account: String):
	return {"action": "account_representative", "account": account}

func account_weight(account: String):
	return {"action": "account_weight", "account": account}

func accounts_balances(accounts: Array):
	return {"action": "accounts_balances", "accounts": accounts}

const telemetry = {"action":"telemetry"}
