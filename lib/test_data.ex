defmodule TestData do
  alias Gateflow.Project.Resources.{Board, FlowItem}

  alias Gateflow.Project.Resources

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

    item =
      item
      |> Ash.Changeset.for_update(:add_parent, %{parent_id: parent.id})
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
