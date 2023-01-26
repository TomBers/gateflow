defmodule BuildTree do
  alias Gateflow.ReadResources

  def run do
    board = ReadResources.get_board("1cd52d70-0db4-4c06-91b5-e9e2387b95b3")
    items = board.flow_items

    # leaf_nodes = get_leaf_nodes(items)

    grouped_by_parent =
      items
      |> Enum.map(fn item ->
        %{
          parent_id: item.flow_item_id,
          id: item.id,
          name: item.title,
          is_root: item.is_root
        }
      end)
      |> Enum.group_by(& &1.parent_id)

    # IO.inspect(grouped_by_parent)

    grouped_by_parent
    |> Map.keys()
    |> build_tree(grouped_by_parent, %{})
  end

  def build_tree([], _all, res) do
    IO.inspect("Exit")
    res
  end

  def build_tree([h | to_add], all, res) do
    children = Map.get(all, h)

    child_map =
      children
      |> Enum.map(fn item -> Map.put_new(item, :children, get_children(item, all)) end)
      |> List.first()

    build_tree(to_add, all, Map.merge(child_map, res))
  end

  # def search_in_order(to_search, _items, acc) when length(to_search) == 0 do
  #   acc
  # end

  # def search_in_order([h | rest], items, acc) do
  #   acc = acc ++ [h.title]
  #   nodes = rest ++ get_children(h, items)
  #   search_in_order(nodes, items, acc)
  # end

  def get_root_items(items) do
    items |> Enum.filter(& &1.is_root)
  end

  def get_leaf_nodes(items) do
    items |> Enum.filter(&(length(&1.children) == 0))
  end

  def get_children(item, items) do
    Map.get(items, item.id)
    # items |> Enum.filter(&(&1.parent_id == item.id))
  end

  def get_item_by_id(id, items) do
    Enum.find(items, &(&1.id == id))
  end
end
