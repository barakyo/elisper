defmodule Elisper do
	require Logger

	def eval([expr | []]) do
		expr
	end

	def eval([expr | args]) when is_binary(expr) do
		# IO.inspect expression
		# IO.puts "eval native"
		expr_atom = String.to_atom(expr)
		eval([expr_atom] ++ args)
	end

	def eval([expr | args] = expression) when is_atom(expr) do
		native_ops = %{
			+: fn (a,b) -> a + b end,
			-: fn (a,b) -> a - b end,
			*: fn (a,b) -> a * b end,
			/: fn (a,b) -> a / b end,
			=: fn (a,b) -> a == b end,
			do: fn(do_args) -> List.last(do_args) end,
			if: fn(conditional, first, second) -> (
				if(conditional) do
					first
				else
					second
				end
			) end
		}
		case Map.get(native_ops, expr) do
			nil -> eval(expression)
			func -> eval([func] ++ args)
		end
	end

	def eval([expr | args] = _expression) do
		# Iterate through the arguments
		# IO.puts "eval - expressions:"
		# IO.inspect _expression
		sub_exprs = Enum.map(args,
			fn
				# Recursively evaluate the argument if it is a list
				([_h | _t] = arg) -> eval(arg)
				# Return the argument if it is just a value
				arg -> arg
			end
		)
		# Execute the function
		# IO.puts "sub expr"
		# IO.inspect sub_exprs
		if is_function(expr, length(sub_exprs)) do
			apply(expr, sub_exprs)
		else
			# IO.puts "expr"
			# IO.inspect expr
			apply(expr, [sub_exprs])
		end
	end


end
