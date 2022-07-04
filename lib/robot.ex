defmodule BackendTest.Robot do
  @moduledoc """
  Struct and context module representing a single robot
  """
  alias BackendTest.Robot

  @type t :: %__MODULE__{orientation: atom(), x: integer(), y: integer(), lost: boolean()}

  @enforce_keys [:orientation, :x, :y]
  defstruct [:orientation, :x, :y, lost: false]

  @spec left(Robot.t()) :: Robot.t()
  def left(%Robot{lost: true} = robot), do: robot
  def left(%Robot{orientation: :north} = robot), do: %{robot | orientation: :west}
  def left(%Robot{orientation: :east} = robot), do: %{robot | orientation: :north}
  def left(%Robot{orientation: :south} = robot), do: %{robot | orientation: :east}
  def left(%Robot{orientation: :west} = robot), do: %{robot | orientation: :south}

  @spec right(Robot.t()) :: Robot.t()
  def right(%Robot{lost: true} = robot), do: robot
  def right(%Robot{orientation: :north} = robot), do: %{robot | orientation: :east}
  def right(%Robot{orientation: :east} = robot), do: %{robot | orientation: :south}
  def right(%Robot{orientation: :south} = robot), do: %{robot | orientation: :west}
  def right(%Robot{orientation: :west} = robot), do: %{robot | orientation: :north}

  @spec forwards(Robot.t(), max_x :: integer(), max_y :: integer()) :: Robot.t()
  def forwards(%Robot{lost: true} = robot, _, _), do: robot

  def forwards(%Robot{orientation: :north, y: y} = robot, _, y), do: %{robot | lost: true}
  def forwards(%Robot{orientation: :north, y: y} = robot, _, _), do: %{robot | y: y + 1}

  def forwards(%Robot{orientation: :east, x: x} = robot, x, _), do: %{robot | lost: true}
  def forwards(%Robot{orientation: :east, x: x} = robot, _, _), do: %{robot | x: x + 1}

  def forwards(%Robot{orientation: :south, y: 0} = robot, _, _), do: %{robot | lost: true}
  def forwards(%Robot{orientation: :south, y: y} = robot, _, _), do: %{robot | y: y - 1}

  def forwards(%Robot{orientation: :west, x: 0} = robot, _, _), do: %{robot | lost: true}
  def forwards(%Robot{orientation: :west, x: x} = robot, _, _), do: %{robot | x: x - 1}
end
