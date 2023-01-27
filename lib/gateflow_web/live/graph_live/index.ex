defmodule GateflowWeb.GraphLive.Index do
  use GateflowWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"board_id" => board_id}, _url, socket) do
    {:noreply, assign(socket, :graph_data, Jason.encode!(Tree.run(board_id)))}
  end
end
