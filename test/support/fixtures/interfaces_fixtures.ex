defmodule Gateflow.InterfacesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gateflow.Interfaces` context.
  """

  @doc """
  Generate a board.
  """
  def board_fixture(attrs \\ %{}) do
    {:ok, board} =
      attrs
      |> Enum.into(%{

      })
      |> Gateflow.Interfaces.create_board()

    board
  end
end
