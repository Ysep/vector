package metadata

remap: errors: "620": {
	title:       "Aborting infallible function"
	description: """
		In VRL, [infallible](\(urls.vrl_error_handling)) functions—functions that can't fail—don't require error
		handling, which in turn means it doesn't make sense to abort on failure using a `!` in the function call.
		"""

	resolution: """
		Remove the `!` from the function call.
		"""

	examples: [
		{
			"title": "\(title)"
			source: #"""
				encode_json!(["one", "two", "three"])
				"""#
			raises: compiletime: #"""
				error: \#(title)
				┌─ :1:1
				│
				1 │ encode_json!(["one", "two", "three"])
				│ ^^^^^^^^^^^- remove this abort-instruction
				│ │
				│ this function cannot fail
				│
				"""#
			diff: #"""
				- 	encode_json!(["one", "two", "three"])
				+# 	encode_json(["one", "two", "three"])
				"""#
		},
	]
}