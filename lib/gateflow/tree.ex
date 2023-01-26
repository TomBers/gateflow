defmodule Tree do
  alias Gateflow.ReadResources

  def run do
    board = ReadResources.get_board("1cd52d70-0db4-4c06-91b5-e9e2387b95b3")
    items = board.flow_items

    leaf_nodes = get_leaf_nodes(items)

    to_merge = replace_parents(leaf_nodes, items)

    merge(to_merge)
  end

  def merge(items) when length(items) == 1 do
    IO.inspect("Exit condition")
    items |> List.first()
  end

  def merge(items) do
    merged =
      items
      |> Enum.reduce(items, fn item, acc -> find_find_children_and_remove_from_acc(item, acc) end)

    merge(merged)
  end

  def find_find_children_and_remove_from_acc(item, acc) do
    children = Enum.filter(acc, fn x -> x.parent_id == item.id end)
    ids_for_removal = Enum.map(children, & &1.id) ++ [item.id]

    if length(children) == 0 do
      acc
    else
      updated_item = Map.update!(item, :children, fn x -> x ++ children end)
      new_acc = Enum.reject(acc, fn x -> Enum.any?(ids_for_removal, &(&1 == x.id)) end)
      [updated_item] ++ new_acc
    end
  end

  def replace_parents(leaf_nodes, all) do
    leaf_nodes
    |> Enum.map(fn node ->
      node_map(get_item_by_id(node.flow_item_id, all), [node_map(node)])
    end)
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
