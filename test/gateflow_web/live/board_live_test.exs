defmodule GateflowWeb.BoardLiveTest do
  use GateflowWeb.ConnCase

  import Phoenix.LiveViewTest
  import Gateflow.InterfacesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_board(_) do
    board = board_fixture()
    %{board: board}
  end

  describe "Index" do
    setup [:create_board]

    test "lists all boards", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/boards")

      assert html =~ "Listing Boards"
    end

    test "saves new board", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/boards")

      assert index_live |> element("a", "New Board") |> render_click() =~
               "New Board"

      assert_patch(index_live, ~p"/boards/new")

      assert index_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#board-form", board: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/boards")

      assert html =~ "Board created successfully"
    end

    test "updates board in listing", %{conn: conn, board: board} do
      {:ok, index_live, _html} = live(conn, ~p"/boards")

      assert index_live |> element("#boards-#{board.id} a", "Edit") |> render_click() =~
               "Edit Board"

      assert_patch(index_live, ~p"/boards/#{board}/edit")

      assert index_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#board-form", board: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/boards")

      assert html =~ "Board updated successfully"
    end

    test "deletes board in listing", %{conn: conn, board: board} do
      {:ok, index_live, _html} = live(conn, ~p"/boards")

      assert index_live |> element("#boards-#{board.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#board-#{board.id}")
    end
  end

  describe "Show" do
    setup [:create_board]

    test "displays board", %{conn: conn, board: board} do
      {:ok, _show_live, html} = live(conn, ~p"/boards/#{board}")

      assert html =~ "Show Board"
    end

    test "updates board within modal", %{conn: conn, board: board} do
      {:ok, show_live, _html} = live(conn, ~p"/boards/#{board}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Board"

      assert_patch(show_live, ~p"/boards/#{board}/show/edit")

      assert show_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#board-form", board: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/boards/#{board}")

      assert html =~ "Board updated successfully"
    end
  end
end
