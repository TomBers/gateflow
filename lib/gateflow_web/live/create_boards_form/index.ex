defmodule GateflowWeb.CreateBoardsFormLive.Index do
  use GateflowWeb, :live_view

  alias Gateflow.ReadResources

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
