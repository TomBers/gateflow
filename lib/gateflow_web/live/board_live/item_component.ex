defmodule GateflowWeb.BoardLive.ItemComponent do
  use GateflowWeb, :live_component

  alias Gateflow.CreateResources
  alias Gateflow.ReadResources

  def render(assigns) do
    ~H"""
    <div class={get_div_class(@offset)}>
      <%= @item.title %> <%= @item.state %>
      <button
        phx-click="add_item"
        phx-value-item={@item.id}
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        Add Item
      </button>
      <%= for item <- @item.children do %>
        <.live_component
          module={GateflowWeb.BoardLive.ItemComponent}
          id={item.id}
          board={@board}
          offset={@offset + 1}
          item={load_children(item)}
        />
      <% end %>
    </div>
    """
  end

  def load_children(item) do
    ReadResources.load_children(item)
  end

  def get_div_class(offset) do
    "outline ml-9"
  end
end
