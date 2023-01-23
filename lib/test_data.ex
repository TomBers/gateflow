defmodule TestData do
  require Ash.Query

  alias Gateflow.Project.Resources.{Board, FlowItem}

  alias Gateflow.Project.Resources

  def read_data do
    # Read ID of all Flow items
    # Gateflow.Project.Resources.FlowItem
    # |> Ash.Query.select([:id])
    # |> Gateflow.Project.Resources.read!()

    items =
      FlowItem
      |> Ash.Query.load([:parents, :board])
      |> Ash.Query.filter(id == "7bb881b8-a292-4113-bf82-73951c86a303")
      |> Resources.read!()

    _item = List.first(items)
  end

  def run do
    board =
      Board
      |> Ash.Changeset.for_create(:create, %{name: "Board name"})
      |> Resources.create!()

    item =
      FlowItem
      |> Ash.Changeset.for_create(:create, %{title: "Flow Item"})
      |> Resources.create!()

    next_item =
      FlowItem
      |> Ash.Changeset.for_create(:create, %{title: "Next Flow Item"})
      |> Resources.create!()
      |> Ash.Changeset.for_update(:set_to_blocked)
      |> Resources.update!()

    parent =
      FlowItem
      |> Ash.Changeset.for_create(:create, %{title: "Parent"})
      |> Resources.create!()

    second_parent =
      FlowItem
      |> Ash.Changeset.for_create(:create, %{title: "Second Parent"})
      |> Resources.create!()

    item =
      item
      |> Ash.Changeset.for_update(:add_parent, %{parent_id: parent.id})
      |> Resources.update!()

    item =
      item
      |> Ash.Changeset.for_update(:add_parent, %{parent_id: second_parent.id})
      |> Resources.update!()

    board =
      board
      |> Ash.Changeset.for_update(:add_flow_item, %{flow_item_id: item.id})
      |> Resources.update!()

    board =
      board
      |> Ash.Changeset.for_update(:add_flow_item, %{flow_item_id: next_item.id})
      |> Resources.update!()

    IO.inspect(board)
  end
end
