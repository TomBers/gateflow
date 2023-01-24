defmodule Gateflow.CreateResources do
  alias Gateflow.Project.Resources.{Board, FlowItem}
  alias Gateflow.Project.Resources

  def create_board(name) do
    Board
    |> Ash.Changeset.for_create(:create, %{name: name})
    |> Resources.create!()
  end

  def create_item(title) do
    FlowItem
    |> Ash.Changeset.for_create(:create, %{title: title})
    |> Resources.create!()
  end

  def set_to_blocked(item) do
    item
    |> Ash.Changeset.for_update(:set_to_blocked)
    |> Resources.update!()
  end

  def set_to_not_blocked(item) do
    item
    |> Ash.Changeset.for_update(:set_to_not_blocked)
    |> Resources.update!()
  end

  def add_to_board(board, item) do
    board
    |> Ash.Changeset.for_update(:add_flow_item, %{flow_item_id: item.id})
    |> Resources.update!()
  end

  def add_child(item, child) do
    item
    |> Ash.Changeset.for_update(:add_child, %{child_id: child.id})
    |> Resources.update!()
  end
end
