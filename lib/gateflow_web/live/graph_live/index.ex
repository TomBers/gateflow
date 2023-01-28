defmodule GateflowWeb.GraphLive.Index do
  use GateflowWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"board_id" => board_id}, _url, socket) do
    trees = SimpleTree.run(board_id) |> Enum.map(&Jason.encode!(&1))
    {:noreply, assign(socket, :graph_data, trees)}
  end
end
