defmodule Gateflow.ReadResources do
  require Ash.Query
  alias Gateflow.Project.Resources

  def build_tree(board) do
    Board
    |> Ash.Query.load(flow_items: [:children])
    |> Ash.Query.filter(id == board.id)
    |> Resources.read!()
  end
end
