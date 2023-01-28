defmodule SimpleTree do
  alias Gateflow.ReadResources

  def run do
    run("1cd52d70-0db4-4c06-91b5-e9e2387b95b3")
  end

  def run(id) do
    board = ReadResources.get_board(id)
    items = board.flow_items

    simplified =
      items
      |> Enum.map(&node_map(&1))

    suited_and_booted =
      simplified
      |> Enum.map(&Map.put(&1, :steps_to_root, steps_to_root(&1, simplified, 0)))
      |> sort_by_steps_to_root

    mash(suited_and_booted)
  end

  def mash(items) do
    items |> merge_to_parent() |> List.first()
    # if Enum.any?(items, &(!&1.is_root)) do
    #   items
    #   |> merge_to_parent([])
    # else
    #   IO.inspect("Exit Condition")
    #   items |> List.first()
    # end
  end

  def steps_to_root(item, _all, cnt) when item.is_root do
    cnt
  end

  def steps_to_root(item, all, cnt) do
    all |> Enum.find(&(&1.id == item.parent_id)) |> steps_to_root(all, cnt + 1)
  end

  def sort_by_steps_to_root(items) do
    Enum.sort(items, fn e1, e2 -> e1.steps_to_root > e2.steps_to_root end)
  end

  def merge_to_parent([h | items] = all) do
    if Enum.all?(all, & &1.is_root) do
      all
    else
      parent = Enum.find(items, &(&1.id == h.parent_id))
      parent_id = Enum.find_index(items, &(&1.id == h.parent_id))
      siblings = Enum.filter(all, &(&1.parent_id == parent.id))
      sibling_ids = Enum.map(siblings, & &1.id)
      # Update parent
      parent = Map.update!(parent, :children, fn x -> x ++ siblings end)
      # IO.inspect(parent, label: "UPDATD PAretn")
      items = List.update_at(items, parent_id, fn _x -> parent end)
      # IO.inspect(items, label: "LIST updated")
      # Filter changed items
      not_changed = Enum.reject(items, &Enum.member?(sibling_ids, &1.id))

      merge_to_parent(not_changed)
    end
  end

  def node_map(item, children \\ []) do
    %{
      id: item.id,
      parent_id: item.flow_item_id,
      name: item.title,
      is_root: item.is_root,
      children: children
    }
  end

  def get_root_items(items) do
    items |> Enum.filter(& &1.is_root)
  end

  def get_leaf_nodes(items) do
    items |> Enum.filter(&(length(&1.children) == 0))
  end

  def get_item_by_id(id, items) do
    Enum.find(items, &(&1.id == id))
  end
end
