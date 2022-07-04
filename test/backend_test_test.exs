defmodule BackendTestTest do
  use ExUnit.Case
  doctest BackendTest

  test "greets the world" do
    assert BackendTest.hello() == :world
  end
end
