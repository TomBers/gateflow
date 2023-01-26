defmodule GateflowWeb.GraphLive.Index do
  use GateflowWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :graph_data, Tree.run())}
  end
end
