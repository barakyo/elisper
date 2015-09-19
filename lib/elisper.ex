defmodule Elisper do

	def eval(expr) do
		scope = Enum.reduce(expr, %{}, fn
			([:def | [func_name, [:fn, params, body]]], acc) -> (
				Map.put(acc, func_name, %{params: params, body: body})
			)
			([:def | arg], acc) -> Map.put(acc, List.first(arg), List.last(arg))
			(arg, acc) -> acc
		end)
		eval(expr, scope)
	end

	def eval([expr | args] = expression, scope) when is_atom(expr) do
    native_ops = %{
      +: fn (a,b) -> a + b end,
      -: fn (a,b) -> a - b end,
      *: fn (a,b) -> a * b end,
      /: fn (a,b) -> a / b end,
      =: fn (a,b) -> a == b end,
			do: fn(_a, b) -> b end,
			print: fn(arg) -> IO.puts "print function #{arg}" end,
			if: fn(conditional, first, second) -> if(conditional) do first else second end end
    }
    case Map.get(native_ops, expr) do
      nil -> (
				if expr == :def || expr == :fn do
					:ok
				else
					case Map.get(scope, expr) do
						%{body: body, params: params} -> (
							new_scope = Enum.zip(params, args)
								|> Enum.reduce(scope, fn({key, val}, acc) -> Map.put(acc, key, val) end)
							eval(body, new_scope)
						)
						nil -> eval(expression, scope)
					end
				end
			)
      func -> eval([func] ++ args, scope)
    end
  end

  def eval([expr | args], scope) do
		sub_exprs = Enum.map(args, fn
			([_h | _t] = arg) -> eval(arg, scope)
			arg -> (
				case Map.get(scope, arg) do
					nil -> arg
					x -> x
				end
			)
		end)
		if is_function(expr, length(sub_exprs)) do
    	apply(expr, sub_exprs)
		else
    	apply(expr, [sub_exprs])
		end
  end

end
