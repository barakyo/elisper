defmodule Elisper do
	require Logger

	defp update_scope([], scope) do
		scope
	end

	defp update_scope([[:def | arg] | t], scope) do
		# [:def | [a, 5], [print 5]]
		# got to a def
		# take the first item
		# IO.inspect "def tail"
		# IO.inspect arg
		key = List.first(arg)
		val = List.last(arg)
		# IO.inspect key
		# IO.inspect val
		if is_list(val) do
			[func_name, params, body] = val
			# Make scope
			# { params: [:greeting, :planet], body: [:print, :greeting, :planet] }
			func_entry = %{ params: params, body: body}
			update_scope(t, Dict.put_new(scope, key, func_entry))
		else
			update_scope(t, Dict.put_new(scope, key, val))
		end
	end

	defp update_scope([h | t], scope) do
		# [do | [def a 5] [print 5]]
		# Ignore head, cont checking tail
		# IO.puts "no def"
		# IO.puts "head: "
		# IO.inspect h
		# IO.puts "tail: "
		# IO.inspect t
		update_scope(t, scope)
	end

	def eval([expr | []]) do
		expr
	end

	def eval(expression) do
		# IO.puts "empty scope"
		# IO.inspect expression
		# Update scope before processing
		scope = update_scope(expression, %{})
		# IO.puts "preproc scope"
		# IO.inspect scope
		eval(expression, scope)
	end

	def eval([expr | args], scope) when is_binary(expr) do
		# IO.inspect expression
		# IO.puts "eval native"
		expr_atom = String.to_atom(expr)
		eval([expr_atom] ++ args)
	end

	def eval([expr | args] = expression, scope) when is_atom(expr) do
		# IO.puts "atom eval expression"
		# IO.inspect expression
		# IO.puts "atom scope"
		# IO.inspect scope
		native_ops = %{
			+: fn (a,b) -> a + b end,
			-: fn (a,b) -> a - b end,
			*: fn (a,b) -> a * b end,
			/: fn (a,b) -> a / b end,
			=: fn (a,b) -> a == b end,
			print: fn(arg) -> IO.puts "print function #{arg}" end,
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
			nil -> (
				if expr == :fn || expr == :def do
					:ok
				else
					case Map.get(scope, expr) do
						func_def -> (
							body = Map.get(func_def, :body)
							params = Map.get(func_def, :params) |> Enum.zip(args)
							# IO.puts "params"
							# IO.inspect params
							new_scope = Enum.reduce(params, scope, fn({key, val}, acc) -> Map.put(acc, key, val) end)
							# IO.puts "new scope"
							# IO.inspect new_scope
							eval(body, new_scope)
						)
						nil -> eval(expression, scope)
					end
				end
			)
			func -> eval([func] ++ args, scope)
		end
	end

	def eval([expr | args] = _expression, scope) do
		# Iterate through the arguments
		# IO.puts "eval - expressions:"
		# IO.inspect _expression
		# IO.puts "eval scope"
		# IO.inspect scope
		sub_exprs = Enum.map(args,
			fn
				# Recursively evaluate the argument if it is a list
				([_h | _t] = arg) -> eval(arg, scope)
				# Return the argument if it is just a value
				arg -> (
					case Map.get(scope, arg) do
						nil -> arg
						x -> x
					end
				)
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
