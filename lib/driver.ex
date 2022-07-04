defmodule BackendTest.Driver do
  @moduledoc """
  Main driver module, which parses a file and runs robot calculations
  """
  alias BackendTest.Robot

  def init(filename) do
    case BackendTest.Parser.load_file(filename) do
      {:ok, max_x, max_y, robots} -> calculate_positions(robots, max_x, max_y)
      {:ok, error} -> IO.puts(error)
    end
  end

  def calculate_positions([], _max_x, _max_y), do: :ok

  def calculate_positions([{robot, instructions} | robots], max_x, max_y) do
    instructions
    |> Enum.reduce(robot, fn
      :left, robot -> Robot.left(robot)
      :right, robot -> Robot.right(robot)
      :forwards, robot -> Robot.forwards(robot, max_x, max_y)
    end)
    |> print_robot()

    calculate_positions(robots, max_x, max_y)
  end

  def print_robot(%Robot{x: x, y: y, orientation: orientation, lost: lost}) do
    IO.puts("(#{x}, #{y}, #{orientation_str(orientation)}) #{lost_str(lost)}")
  end

  def orientation_str(:north), do: "N"
  def orientation_str(:east), do: "E"
  def orientation_str(:south), do: "S"
  def orientation_str(:west), do: "W"

  def lost_str(true), do: "LOST"
  def lost_str(false), do: ""
end
