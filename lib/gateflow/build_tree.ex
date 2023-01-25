defmodule BuildTree do
  alias Gateflow.ReadResources

  def run do
    board = ReadResources.get_board("156f7c2e-59ea-4aaa-bd97-af98919a7bba")
    items = board.flow_items

    # _leaf_nodes = get_leaf_nodes(items)

    roots = get_root_items(items)

    search_in_order(roots, items, [])
  end

  def search_in_order(to_search, _items, acc) when length(to_search) == 0 do
    acc
  end

  def search_in_order([h | rest], items, acc) do
    acc = acc ++ [h.title]
    nodes = rest ++ get_children(h, items)
    search_in_order(nodes, items, acc)
  end

  def add_nodes(_node, acc, _items, []) do
    acc
  end

  def add_nodes(node, acc, items, children) do
    # acc =
    Map.put_new(acc, :name, node.title)
    |> Map.put_new(
      :children,
      Enum.map(children, &%{name: &1.title, children: get_children(&1, items)})
    )

    # TODO rewrite as a recursive function to make sure we go down multiple levels.

    # children
    # |> Enum.map(fn child -> add_nodes(child, acc, items, get_children(child, items)) end)
  end

  def get_root_items(items) do
    items |> Enum.filter(& &1.is_root)
  end

  def get_leaf_nodes(items) do
    items |> Enum.filter(&(length(&1.children) == 0))
  end

  def get_children(item, items) do
    items |> Enum.filter(&(&1.flow_item_id == item.id))
  end
end
