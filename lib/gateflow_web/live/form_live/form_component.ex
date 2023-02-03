defmodule GateflowWeb.FormLive.BoardFormComponent do
  use GateflowWeb, :live_component

  alias Gateflow.CreateResources
  alias Gateflow.Project.Resources.{Board, FlowItem}

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        :let={f}
        for={@form}
        id="board-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>

        <%= for flow_items_form <- Phoenix.HTML.Form.inputs_for(f, :flow_items) do %>
          <.input field={{flow_items_form, :title}} type="text" label="Title" />
          <.input field={{flow_items_form, :id}} type="hidden" />
        <% end %>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{board: board} = assigns, socket) do
    form =
      if board do
        AshPhoenix.Form.for_action(board, :update,
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
      else
        AshPhoenix.Form.for_action(Gateflow.Project.Resources.Board, :create,
          api: Gateflow.Project.Resources,
          forms: [
            flow_items: [
              type: :list,
              as: "flow_items_form",
              resource: FlowItem,
              create_action: :create
            ]
          ]
        )
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, form)}
  end

  @impl true
  def handle_event("validate", %{"form" => board_params}, socket) do
    {:noreply, assign(socket, :form, AshPhoenix.Form.validate(socket.assigns.form, board_params))}
  end

  def handle_event("save", %{"form" => form_params}, socket) do
    if socket.assigns.form.type == :update do
      # Manually updating Sub form items, not sure if the right approach
      Map.get(form_params, "flow_items", [])
      |> Enum.map(fn {_k, %{"id" => item_id, "title" => title}} ->
        CreateResources.change_name(item_id, title)
      end)
    end

    case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
      {:ok, _tweet} ->
        message =
          case socket.assigns.form.type do
            :create ->
              "Board created successfully"

            :update ->
              "Board updated successfully"
          end

        {:noreply,
         socket
         |> put_flash(:info, message)
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end
end
