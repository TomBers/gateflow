defmodule GateflowWeb.SimpleFormLive.Index do
  use GateflowWeb, :live_view
  use Phoenix.Component

  alias Gateflow.ReadResources
  alias Gateflow.CreateResources

  @impl
  def mount(params, _, socket) do
    board = ReadResources.get_board(params["board_id"])

    form =
      board
      |> AshPhoenix.Form.for_update(
        :update,
        api: Gateflow.Project.Resources,
        forms: [
          flow_items: [
            type: :list,
            as: "flow_items_form",
            data: board.flow_items,
            resource: FlowItem,
            update_action: :update
          ]
        ]
      )

    socket =
      assign(socket,
        form: form
      )
      |> assign(:board_id, board.id)

    {:ok, socket}
  end

  @impl
  def render(assigns) do
    ~H"""
    <div class="page">
      <div class="page-content">
        <div class="page-header">
          <h1>Board</h1>
        </div>
        <div class="panel">
          <div class="panel__content">
            <.form :let={f} for={@form} phx-submit="save">
              <div class="form-control">
                <.input field={{f, :name}} type="text" label="Name" />
              </div>

              <%= for flow_items_form <- Phoenix.HTML.Form.inputs_for(f, :flow_items) do %>
                <.input field={{flow_items_form, :title}} type="text" label="Title" />
                <.input field={{flow_items_form, :id}} type="hidden" />
              <% end %>

              <.button phx-disable-with="Saving..." type="submit">Save</.button>
            </.form>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl
  def handle_event("save", %{"form" => params}, socket) do
    Map.get(params, "flow_items", [])
    |> Enum.map(fn {_k, %{"id" => item_id, "title" => title}} ->
      CreateResources.change_name(item_id, title)
    end)

    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    case AshPhoenix.Form.submit(form) do
      {:ok, result} ->
        {:noreply, push_navigate(socket, to: "/simpleform/#{socket.assigns.board_id}")}

      {:error, form} ->
        assign(socket, :form, form)
    end
  end
end
