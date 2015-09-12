defmodule Elisper do

	def eval([expr | args] = expression) when is_binary(expr) do
		# IO.puts "eval native"
		native_ops = %{
			+: fn (a,b) -> a + b end,
			-: fn (a,b) -> a - b end,
			*: fn (a,b) -> a * b end,
			/: fn (a,b) -> a / b end
		}
		expr_atom = String.to_atom(expr)
		case Map.get(native_ops, expr_atom) do
			nil -> eval(expression)
			func -> eval([func] ++ args)
		end
	end

	def eval([expr | args]) do
		# Iterate through the arguments
		sub_exprs = Enum.map(args,
			fn
				# Recursively evaluate the argument if it is a list
				([_h | _t] = arg) -> eval(arg)
				# Return the argument if it is just a value
				arg -> arg
			end
		)
		# Execute the function
		apply(expr, sub_exprs)
	end

end
