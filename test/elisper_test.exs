defmodule ElisperTest do
  use ExUnit.Case, async: true

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "sum function" do
    sum = fn (a, b) -> a + b end
    assert (Elisper.eval([sum, 1, 2])) == 3
  end

  test "native addition function" do
    assert (Elisper.eval(["+", 1, 2])) == 3
  end

  test "native equality function" do
    assert (Elisper.eval(["=", 1, 1])) == true
  end

  test "native multiplication function" do
    assert (Elisper.eval(["*", 1, 2])) == 2
  end

  test "native subtraction function" do
    assert (Elisper.eval(["-", 1, 2])) == -1
  end

  test "native division function" do
    assert (Elisper.eval(["/", 2, 2])) == 1
  end

  test "recursive arguments" do
    assert (Elisper.eval(["+", 1, ["-", 2, 2]])) == 1
  end

  test "two recursive arguments" do
    assert (Elisper.eval(["+", ["+", 1, 1], ["+", 1, 1]])) == 4
  end

  test "three recursive arguments" do
    assert (Elisper.eval(["+", ["+", ["+", 1, 1], 1], ["+", 1, 1]])) == 5
  end

  test "do clause" do
    assert (
      Elisper.eval(
        ["do",
          [IO.puts "hello"],
          [IO.puts "world"]
        ]
      )
    ) == :ok
    assert (
      Elisper.eval(
        ["do",
          ["+", 1, 1],
          ["+", 1, 1]
        ]
      )
    ) == 2
  end

end
