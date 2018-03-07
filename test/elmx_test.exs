defmodule ElmxTest do
  use ExUnit.Case
  doctest Elmx

  test "greets the world" do
    assert Elmx.hello() == :world
  end
end
