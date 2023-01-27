defmodule Tree do
  alias Gateflow.ReadResources

  def run do
    run("156f7c2e-59ea-4aaa-bd97-af98919a7bba")
  end

  def run(id) do
    board = ReadResources.get_board(id)
    items = board.flow_items

    leaf_nodes = get_leaf_nodes(items)

    to_merge = replace_parents(leaf_nodes, items)

    merge(to_merge)
  end

  def merge(items) do
    # TODO - merge_common_parents seems a better approach
    merged =
      items
      |> Enum.reduce(items, fn item, acc -> find_find_children_and_remove_from_acc(item, acc) end)

    IO.inspect(Enum.any?(merged, &(&1.is_root == false)),
      label: "Any no root nodes at top level"
    )

    IO.inspect(merged)

    # Exit condition - all top top level nodes are root nodes
    if Enum.any?(merged, &(&1.is_root == false)) do
      merge(merged)
    else
      IO.inspect("Exit condition")
      merged |> List.first()
    end
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
    converted_leaf_nodes =
      leaf_nodes
      |> Enum.map(fn node ->
        node_map(get_item_by_id(node.flow_item_id, all), [node_map(node)])
      end)
      |> merge_common_parents([])

    ln_ids = Enum.map(leaf_nodes, & &1.id) ++ Enum.map(converted_leaf_nodes, & &1.id)

    # These are all the nodes that are neither leaf not parents of leaf nodes
    rest =
      all
      |> Enum.reject(fn item -> Enum.any?(ln_ids, fn x -> item.id == x end) end)
      |> Enum.map(&node_map(&1))

    rest ++ converted_leaf_nodes
  end

  def merge_common_parents([], acc) do
    acc
  end

  def merge_common_parents([h | items], acc) do
    common = Enum.filter(items, &(&1.id == h.id))
    unique = Enum.reject(items, &(&1.id == h.id))

    new_acc =
      Enum.reduce(common, h, fn item, acc ->
        Map.update!(acc, :children, fn x -> x ++ item.children end)
      end)

    merge_common_parents(unique, acc ++ [new_acc])
  end

  def merge_helper(:children, v1, v2) do
    v1 ++ v2
  end

  def merge_helper(_k, v1, _v2) do
    v1
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
