defmodule GateflowWeb.FormLive.BoardFormComponent do
  use GateflowWeb, :live_component

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
        <.input field={{f, :name}} type="text" label="Title" />
        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{board: board} = assigns, socket) do
    form =
      if board do
        AshPhoenix.Form.for_action(board, :update,
          as: "board",
          api: Gateflow.Project.Resources,
          forms: [auto?: true]
        )
      else
        AshPhoenix.Form.for_action(Gateflow.Project.Resources.Board, :create,
          as: "board",
          api: Gateflow.Project.Resources
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
