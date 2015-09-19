defmodule ElisperTest do
  use ExUnit.Case, async: true

  test "sum function" do
    sum = fn (a, b) -> a + b end
    assert (Elisper.eval([sum, 1, 2])) == 3
  end

  test "native addition function" do
    assert (Elisper.eval([:+, 1, 2])) == 3
  end

  test "two recursive arguments" do
    assert (Elisper.eval([:+, [:+, 1, 1], [:+, 1, 1]])) == 4
 end

 test "def" do
   assert (Elisper.eval([:do, [:def, :a, 5], [:+, :a, :a]])) == 10
 end

  test "native equality function" do
    assert (Elisper.eval([:=, 1, 1])) == true
  end

  test "native multiplication function" do
    assert (Elisper.eval([:*, 1, 2])) == 2
  end

  test "native subtraction function" do
    assert (Elisper.eval([:-, 1, 2])) == -1
  end

  test "native division function" do
    assert (Elisper.eval([:/, 2, 2])) == 1
  end

  test "recursive arguments" do
    assert (Elisper.eval([:+, 1, [:-, 2, 2]])) == 1
  end

  test "three recursive arguments" do
    assert (Elisper.eval([:+, [:+, [:+, 1, 1], 1], [:+, 1, 1]])) == 5
  end

  test "do clause" do
    assert (
      Elisper.eval(
        [:do,
          [:print, "hello"],
          [:print, "world"]
        ]
      )
    ) == :ok
    assert (
      Elisper.eval(
        [:do,
          [:+, 1, 1],
          [:+, 1, 1]
        ]
      )
    ) == 2
  end

 test "if clause" do
   assert (Elisper.eval([:if, [:=, 1, 1], [:+, 1, 1], [:+, 2, 2]])) == 2
 end

 test "def" do
   assert (Elisper.eval([:def, :a, 5])) == :ok
   assert (Elisper.eval([:do, [:def, :a, 5], [:print, :a]])) == :ok
   assert (Elisper.eval([:do, [:def, :a, 5], [:+, :a, :a]])) == 10
 end

 test "def fn" do
   Elisper.eval(
     [:do,
      [:def, :shout,
        [:fn, [:planet, :greeting],
          [:print, :greeting, :planet]
        ]
      ],
      [:shout, "world", "hello"]
     ]
   )
  assert (Elisper.eval(
     [:do,
      [:def, :multi,
        [:fn, [:x, :y],
          [:*, :x, :y]
        ]
      ],
      [:multi, 3, 4]
     ]
   )) == 12
 end

end
