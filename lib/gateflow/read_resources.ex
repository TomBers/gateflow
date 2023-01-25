defmodule Gateflow.ReadResources do
  require Ash.Query

  alias Gateflow.Project.Resources.{Board, FlowItem}
  alias Gateflow.Project.Resources

  def get_board(board_id) do
    Board
    |> Ash.Query.load(flow_items: [:children])
    # |> Ash.Query.load(:flow_items)
    |> Ash.Query.filter(id == ^board_id)
    |> Resources.read!()
    |> List.first()
  end

  def get_item_by_id(item_id) do
    FlowItem
    |> Ash.Query.filter(id == ^item_id)
    |> Resources.read!()
    |> List.first()
  end

  def load_children(item) do
    FlowItem
    |> Ash.Query.load(:children)
    |> Ash.Query.filter(id == ^item.id)
    |> Resources.read!()
    |> List.first()
  end
end
