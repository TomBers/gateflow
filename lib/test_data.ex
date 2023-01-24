defmodule TestData do
  require Ash.Query

  alias Gateflow.Project.Resources.{Board, FlowItem}

  alias Gateflow.Project.Resources

  def build_tree do
    Board
    |> Ash.Query.load(flow_items: [:children])
    |> Ash.Query.filter(id == "afca4da1-84eb-4b97-ad23-59a027ad9991")
    |> Resources.read!()
  end

  def read_data do
    # Read ID of all Flow items
    # Gateflow.Project.Resources.FlowItem
    # |> Ash.Query.select([:id])
    # |> Gateflow.Project.Resources.read!()

    items =
      FlowItem
      |> Ash.Query.load([:children, :board])
      |> Ash.Query.filter(id == "cc41d90e-b173-4472-9a5f-db1fbc95b892")
      |> Resources.read!()

    List.first(items)
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
      |> Ash.Changeset.for_update(:set_to_blocked)
      |> Resources.update!()

    child =
      FlowItem
      |> Ash.Changeset.for_create(:create, %{title: "Child"})
      |> Resources.create!()

    second_child =
      FlowItem
      |> Ash.Changeset.for_create(:create, %{title: "Second Child"})
      |> Resources.create!()

    board =
      board
      |> Ash.Changeset.for_update(:add_flow_item, %{flow_item_id: item.id})
      |> Resources.update!()

    board =
      board
      |> Ash.Changeset.for_update(:add_flow_item, %{flow_item_id: child.id})
      |> Resources.update!()

    board
    |> Ash.Changeset.for_update(:add_flow_item, %{flow_item_id: second_child.id})
    |> Resources.update!()

    item =
      item
      |> Ash.Changeset.for_update(:add_child, %{child_id: child.id})
      |> Resources.update!()

    item
    |> Ash.Changeset.for_update(:add_child, %{child_id: second_child.id})
    |> Resources.update!()
  end
end
