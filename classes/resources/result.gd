class_name Result extends Resource

var _is_ok: bool
var _value: Variant
var _error: Variant

func _init(ok: bool, value: Variant = null, error: Variant = null) -> void:
	_is_ok = ok
	_value = value
	_error = error

static func ok(value: Variant = null) -> Result:
	return Result.new(true, value, null)

static func err(error: Variant) -> Result:
	return Result.new(false, null, error)

func is_ok() -> bool:
	return _is_ok

func is_err() -> bool:
	return not _is_ok

func unwrap() -> Variant:
	assert(_is_ok, "Called unwrap() on an Err: %s" % [_error])
	return _value

func unwrap_err() -> Variant:
	assert(not _is_ok, "Called unwrap_err() on an Ok: %s" % [_value])
	return _error

func unwrap_or(default: Variant) -> Variant:
	return _value if _is_ok else default

func unwrap_or_else(f: Callable) -> Variant:
	return _value if _is_ok else f.call(_error)

func expect(msg: String) -> Variant:
	assert(_is_ok, "%s: %s" % [msg, _error])
	return _value

func map(f: Callable) -> Result:
	return Result.ok(f.call(_value)) if _is_ok else self

func map_err(f: Callable) -> Result:
	return self if _is_ok else Result.err(f.call(_error))

static func collect(results: Array[Result]) -> Result:
	var values := []
	for r in results:
		if r.is_err():
			return r
		values.append(r.unwrap())
	return Result.ok(values)

func _to_string() -> String:
	return "Ok(%s)" % [_value] if _is_ok else "Err(%s)" % [_error]
