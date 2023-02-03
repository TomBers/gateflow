defmodule GateflowWeb.FormLive.Index do
  use GateflowWeb, :live_view

  alias Gateflow.ReadResources

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"board_id" => board_id}, _url, socket) do
    board = ReadResources.get_board(board_id)
    # IO.inspect(board)
    {:noreply, assign(socket, :board, board)}
  end
end
