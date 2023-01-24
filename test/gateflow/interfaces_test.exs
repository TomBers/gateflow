defmodule Gateflow.InterfacesTest do
  use Gateflow.DataCase

  alias Gateflow.Interfaces

  describe "boards" do
    alias Gateflow.Interfaces.Board

    import Gateflow.InterfacesFixtures

    @invalid_attrs %{}

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Interfaces.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Interfaces.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      valid_attrs = %{}

      assert {:ok, %Board{} = board} = Interfaces.create_board(valid_attrs)
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Interfaces.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      update_attrs = %{}

      assert {:ok, %Board{} = board} = Interfaces.update_board(board, update_attrs)
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Interfaces.update_board(board, @invalid_attrs)
      assert board == Interfaces.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Interfaces.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Interfaces.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Interfaces.change_board(board)
    end
  end
end
