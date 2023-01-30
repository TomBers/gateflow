defmodule SimpleTree do
  alias Gateflow.ReadResources

  def run do
    run("1cd52d70-0db4-4c06-91b5-e9e2387b95b3")
  end

  def run(id) do
    board = ReadResources.get_board(id)
    items = board.flow_items

    items
    |> Enum.map(&node_map(&1, items))
    |> sort_by_steps_to_root
    |> merge_to_parent()
  end

  def steps_to_root(item, all) do
    steps_to_root(item, all, 0)
  end

  def steps_to_root(item, _all, cnt) when item.is_root do
    cnt
  end

  def steps_to_root(item, all, cnt) do
    all |> Enum.find(&(&1.id == item.flow_item_id)) |> steps_to_root(all, cnt + 1)
  end

  # Start with the furthest nodes away and move close to the root node
  def sort_by_steps_to_root(items) do
    Enum.sort(items, fn e1, e2 -> e1.steps_to_root > e2.steps_to_root end)
  end

  def merge_to_parent(all) do
    if Enum.all?(all, & &1.is_root) do
      all
    else
      all
      |> update_parent_in_place()
      |> merge_to_parent()
    end
  end

  defp update_parent_in_place([h | items] = all) do
    parent = Enum.find(items, &(&1.id == h.parent_id))
    parent_id = Enum.find_index(items, &(&1.id == h.parent_id))

    siblings = Enum.filter(all, &(&1.parent_id == parent.id))
    sibling_ids = Enum.map(siblings, & &1.id)

    # Update parent
    parent = Map.update!(parent, :children, fn x -> x ++ siblings end)

    # Add updated parent to items and filter the moved children
    items
    |> List.update_at(parent_id, fn _x -> parent end)
    |> Enum.reject(&Enum.member?(sibling_ids, &1.id))
  end

  def node_map(item, all) do
    state = get_any_blocked(item, all)

    %{
      id: item.id,
      parent_id: item.flow_item_id,
      name: item.title,
      is_root: item.is_root,
      state: state,
      children: [],
      steps_to_root: steps_to_root(item, all),
      itemStyle: %{
        # borderType: "dotted",
        color: ReadResources.item_col(state)
      }
    }
  end

  def get_any_blocked(item, _all) when item.is_root do
    item.state
  end

  def get_any_blocked(item, all) do
    if item.state == :blocked do
      :blocked
    else
      all |> Enum.find(&(&1.id == item.flow_item_id)) |> get_any_blocked(all)
    end
  end
end
