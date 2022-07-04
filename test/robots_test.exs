defmodule BackendTest.RobotTest do
  @moduledoc """
  Tests for the Robots module
  """
  use ExUnit.Case, async: true
  alias BackendTest.Robot

  describe "turning left and right" do
    test "lost robots stay where they are" do
      robot = %Robot{orientation: :west, x: 0, y: 0, lost: true}

      assert Robot.left(robot) == robot
      assert Robot.right(robot) == robot
    end

    test "non-lost robots can turn as expected" do
      start_orientations = [:north, :east, :south, :west]

      robots =
        Enum.map(start_orientations, fn orientation ->
          %Robot{orientation: orientation, x: 0, y: 0, lost: false}
        end)

      expected_end_orientations = [:west, :north, :east, :south]

      result =
        Enum.map(robots, fn robot ->
          robot
          |> Robot.left()
          |> Map.get(:orientation)
        end)

      assert result == expected_end_orientations

      expected_end_orientations = [:east, :south, :west, :north]

      result =
        Enum.map(robots, fn robot ->
          robot
          |> Robot.right()
          |> Map.get(:orientation)
        end)

      assert result == expected_end_orientations
    end
  end

  describe "moving forwards" do
    test "lost robots stay where they are" do
      robot = %Robot{orientation: :west, x: 0, y: 0, lost: true}

      assert Robot.forwards(robot, 4, 4) == robot
    end

    test "attempting to move outside the grid causes robot to be lost and stay where it is" do
      max_x = 4
      max_y = 4

      robot = %Robot{orientation: :north, x: 0, y: 4}
      expected = %Robot{orientation: :north, x: 0, y: 4, lost: true}
      assert Robot.forwards(robot, max_x, max_y) == expected

      robot = %Robot{orientation: :east, x: 4, y: 0}
      expected = %Robot{orientation: :east, x: 4, y: 0, lost: true}
      assert Robot.forwards(robot, max_x, max_y) == expected

      robot = %Robot{orientation: :south, x: 0, y: 0}
      expected = %Robot{orientation: :south, x: 0, y: 0, lost: true}
      assert Robot.forwards(robot, max_x, max_y) == expected

      robot = %Robot{orientation: :west, x: 0, y: 0}
      expected = %Robot{orientation: :west, x: 0, y: 0, lost: true}
      assert Robot.forwards(robot, max_x, max_y) == expected
    end

    test "non-lost robots can move as expected" do
      max_x = 4
      max_y = 4

      robot = %Robot{orientation: :north, x: 0, y: 3}
      expected = %Robot{orientation: :north, x: 0, y: 4, lost: false}
      assert Robot.forwards(robot, max_x, max_y) == expected

      robot = %Robot{orientation: :east, x: 3, y: 0}
      expected = %Robot{orientation: :east, x: 4, y: 0, lost: false}
      assert Robot.forwards(robot, max_x, max_y) == expected

      robot = %Robot{orientation: :south, x: 0, y: 1}
      expected = %Robot{orientation: :south, x: 0, y: 0, lost: false}
      assert Robot.forwards(robot, max_x, max_y) == expected

      robot = %Robot{orientation: :west, x: 1, y: 0}
      expected = %Robot{orientation: :west, x: 0, y: 0, lost: false}
      assert Robot.forwards(robot, max_x, max_y) == expected
    end
  end
end
