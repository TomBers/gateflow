defmodule GateflowWeb.BoardLive.Index do
  use GateflowWeb, :live_view

  alias GateflowWeb.BoardLive.ItemComponent

  alias Gateflow.ReadResources
  alias Gateflow.CreateResources

  @impl true
  def mount(_params, _session, socket) do
    GateflowWeb.Endpoint.subscribe("flow_items:created")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"board_id" => board_id}, _url, socket) do
    board = ReadResources.get_board(board_id)
    # IO.inspect(board)
    {:noreply, assign(socket, :board, board)}
  end

  @impl
  def handle_event("add_root_item", _params, socket) do
    new_item =
      CreateResources.create_root_item("Root item #{length(socket.assigns.board.flow_items)}")

    board = CreateResources.add_to_board(socket.assigns.board, new_item)
    {:noreply, assign(socket, :board, board)}
  end

  def handle_event("add_item", %{"item" => item_id}, socket) do
    board = socket.assigns.board
    child = CreateResources.create_item("Child #{length(board.flow_items)}", board.id)
    board = CreateResources.add_to_board(board, child)
    CreateResources.add_child_via_item_id(item_id, child)

    {:noreply, assign(socket, :board, board)}
  end

  def handle_info(
        %Phoenix.Socket.Broadcast{
          topic: "flow_items:created",
          payload: payload
        } = params,
        socket
      ) do
    IO.inspect(params, label: "Params")
    {:noreply, socket}
  end

  def load_children(item) do
    ReadResources.load_children(item)
  end

  def get_root_items(items) do
    items |> Enum.filter(& &1.is_root)
  end
end
