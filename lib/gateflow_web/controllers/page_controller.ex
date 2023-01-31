defmodule GateflowWeb.PageController do
  use GateflowWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def api(conn, %{"board_id" => board_id}) do
    IO.inspect(board_id, label: "Board ID")
    json(conn, SimpleTree.run(board_id))
  end
end
