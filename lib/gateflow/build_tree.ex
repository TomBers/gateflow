defmodule BuildTree do
  alias Gateflow.ReadResources

  def run do
    board = ReadResources.get_board("1cd52d70-0db4-4c06-91b5-e9e2387b95b3")
    items = board.flow_items
    roots = get_root_items(items)

    roots
    |> Enum.reduce(%{}, &add_nodes(&1, &2, items, get_children(&1, items)))
  end

  def add_nodes(node, acc, items, []) do
    acc
  end

  def add_nodes(node, acc, items, children) do
    acc =
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

  def get_children(item, items) do
    items |> Enum.filter(&(&1.flow_item_id == item.id))
  end
end
