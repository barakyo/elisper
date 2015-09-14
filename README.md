Elisper
=======
[![Build Status](https://travis-ci.org/barakyo/elisper.svg?branch=master)](https://travis-ci.org/barakyo/elisper)

An experimental implementation of a subset of lisp in Elixir.

This was mainly a fun project based off of the blog post,
[Lisp In Your Own Language](http://danthedev.com/2015/09/09/lisp-in-your-language/),
by Dan Prince.

Some things that are supported:

#### Evaluation ####
	iex(2)> Elisper.eval([:+, 1, 1])
	2

	iex(3)> Elisper.eval([:+, [:+, 2, 2], [:+, 2, 3]])
	9

#### Do Clauses ####

	iex(5)> Elisper.eval([:do, [:print, "hello"], [:print, "world"]])
	print function hello
	print function world
	:ok

#### If Statements ####

	iex(7)> Elisper.eval([:if, [:=, 1, 1], [:+, 1, 1], [:+, 2, 2]])
	2

#### Functions ####

	iex(9)> Elisper.eval(
	...(9)> [:do,
	...(9)>       [:def, :multi,
	...(9)>         [:fn, [:x, :y],
	...(9)>           [:*, :x, :y]
	...(9)>         ]
	...(9)>       ],
	...(9)>       [:multi, 3, 4]
	...(9)>      ]
	...(9)> )
	12
