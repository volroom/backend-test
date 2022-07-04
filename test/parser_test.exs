defmodule BackendTest.ParserTest do
  @moduledoc """
  Tests for the Parser module
  """
  use ExUnit.Case, async: true
  alias BackendTest.Parser

  describe "get_grid_size" do
    test "returns ok tuple for valid grid specifications" do
      assert Parser.get_grid_size("4 8") == {:ok, 4, 8}
      assert Parser.get_grid_size("10 11") == {:ok, 10, 11}
    end

    test "returns error tuple for invalid grid specifications" do
      assert Parser.get_grid_size("A 8") == {:error, "Invalid grid specification: A 8"}
      assert Parser.get_grid_size("") == {:error, "Invalid grid specification: "}
    end
  end
end
