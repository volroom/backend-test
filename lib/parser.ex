defmodule BackendTest.Parser do
  @moduledoc """
  Parses files to set up the grid and any robots
  """

  @doc """
  Loads given file, parses it, returning grid dimensions and list of robots and their movements
  """
  def load_file(filename) do
    filename
    |> File.read()
    |> case do
      {:ok, text} ->
        text
        |> String.split("\n", trim: true)
        |> parse()

      error ->
        error
    end
  end

  def parse([grid_spec | rest]) do
    with {:ok, max_x, max_y} <- get_grid_size(grid_spec),
         {:ok, robots} <- get_robots(rest) do
      {:ok, max_x, max_y, robots}
    end
  end

  def parse(_), do: {:error, "Invalid file"}

  def get_grid_size(grid) do
    with %{"max_x" => max_x, "max_y" => max_y} <-
           Regex.named_captures(~r/^(?<max_x>\d+)\s(?<max_y>\d+)$/, grid),
         {int_max_x, ""} <- Integer.parse(max_x),
         {int_max_y, ""} <- Integer.parse(max_y) do
      {:ok, int_max_x, int_max_y}
    else
      _ -> {:error, "Invalid grid specification: #{grid}"}
    end
  end

  def get_robots(robot_specs, robots \\ [])

  def get_robots([], robots), do: {:ok, Enum.reverse(robots)}

  def get_robots(
        [
          <<"(", x::binary-size(1), ", ", y::binary-size(1), ", ", orientation::binary-size(1),
            ") ", instructions::binary>> = specification
          | rest
        ],
        robots
      ) do
    with {int_x, ""} <- Integer.parse(x),
         {int_y, ""} <- Integer.parse(y),
         {:ok, orientation} <- string_to_orientation(orientation),
         {:ok, instructions} <- parse_instructions(instructions) do
      robot = %BackendTest.Robot{x: int_x, y: int_y, orientation: orientation}
      get_robots(rest, [{robot, instructions} | robots])
    else
      _ -> {:error, "Invalid robot specification: #{specification}"}
    end
  end

  def get_robots([invalid | _rest], _robots) do
    {:error, "Invalid robot specification: #{invalid}"}
  end

  def string_to_orientation("N"), do: {:ok, :north}
  def string_to_orientation("E"), do: {:ok, :east}
  def string_to_orientation("S"), do: {:ok, :south}
  def string_to_orientation("W"), do: {:ok, :west}
  def string_to_orientation(_), do: {:error, "Invalid orientation"}

  def parse_instructions(instructions, instructions_list \\ [])

  def parse_instructions("", instructions_list), do: {:ok, Enum.reverse(instructions_list)}

  def parse_instructions(<<"L", rest::binary>>, instructions_list) do
    parse_instructions(rest, [:left | instructions_list])
  end

  def parse_instructions(<<"R", rest::binary>>, instructions_list) do
    parse_instructions(rest, [:right | instructions_list])
  end

  def parse_instructions(<<"F", rest::binary>>, instructions_list) do
    parse_instructions(rest, [:forwards | instructions_list])
  end

  def parse_instructions(_, _instructions_list), do: {:error, "Invalid instructions"}
end
