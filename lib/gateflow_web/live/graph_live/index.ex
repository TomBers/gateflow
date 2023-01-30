defmodule GateflowWeb.GraphLive.Index do
  use GateflowWeb, :live_view

  alias Gateflow.ReadResources
  alias Gateflow.CreateResources

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"board_id" => board_id}, _url, socket) do
    trees = SimpleTree.run(board_id) |> Enum.map(&Jason.encode!(&1))
    {:noreply, assign(socket, :graph_data, trees) |> assign(:board_id, board_id)}
  end

  @impl true
  def handle_event("node_clicked", data, socket) do
    item_id = Map.get(data, "id")

    item_id
    |> ReadResources.get_item_by_id()
    |> CreateResources.change_state()

    trees = SimpleTree.run(socket.assigns.board_id) |> Enum.map(&Jason.encode!(&1))
    {:noreply, assign(socket, :graph_data, trees)}
  end
end
