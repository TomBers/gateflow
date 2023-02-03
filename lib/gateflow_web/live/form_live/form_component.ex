defmodule GateflowWeb.FormLive.BoardFormComponent do
  use GateflowWeb, :live_component

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
              update_action: :update,
              create_action: :create
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
              update_action: :update,
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
  def handle_event("validate", %{"board" => board_params}, socket) do
    {:noreply, assign(socket, :form, AshPhoenix.Form.validate(socket.assigns.form, board_params))}
  end

  def handle_event("save", %{"board" => board_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: board_params) do
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
