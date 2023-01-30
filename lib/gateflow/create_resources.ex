defmodule Gateflow.CreateResources do
  alias Gateflow.Project.Resources.{Board, FlowItem}
  alias Gateflow.Project.Resources

  def create_board(name) do
    Board
    |> Ash.Changeset.for_create(:create, %{name: name})
    |> Resources.create!()
  end

  # def create_item(title) do
  #   FlowItem
  #   |> Ash.Changeset.for_create(:create, %{title: title})
  #   |> Resources.create!()
  # end

  @spec create_item(any, any) :: {struct, [Ash.Notifier.Notification.t()]} | struct
  def create_item(title, board_id) do
    FlowItem
    |> Ash.Changeset.for_create(:create, %{title: title, board_id: board_id})
    |> Resources.create!()
  end

  def create_root_item(title) do
    FlowItem
    |> Ash.Changeset.for_create(:create, %{title: title, is_root: true})
    |> Resources.create!()
  end

  def change_state(item) do
    change_state(item, item.state)
  end

  def change_state(item, :blocked) do
    set_to_not_blocked(item)
  end

  def change_state(item, :not_blocked) do
    set_to_blocked(item)
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

  def add_child_via_item_id(item_id, child) do
    add_child(Gateflow.ReadResources.get_item_by_id(item_id), child)
  end
end
