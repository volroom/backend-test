defmodule Mix.Tasks.CalculateRobots do
  @moduledoc """
  Mix task for calculate robot positions: `mix calculate_robots priv/example_1`
  """
  use Mix.Task

  def run(filename) do
    BackendTest.Driver.init(filename)
  end
end
