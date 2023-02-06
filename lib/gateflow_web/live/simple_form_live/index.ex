defmodule GateflowWeb.SimpleFormLive.Index do
  use GateflowWeb, :live_view
  use Phoenix.Component

  require Ash.Query
  alias Gateflow.Project.Resources
  alias Gateflow.Family.Resources.{Parent, Child, GrandChild}

  @impl
  def mount(params, _, socket) do
    parent_id = params["parent_id"]

    parent =
      Parent
      # |> Ash.Query.load()
      |> Ash.Query.load([:children])
      |> Ash.Query.filter(id == ^parent_id)
      |> Resources.read!()
      |> List.first()

    form =
      parent
      |> AshPhoenix.Form.for_update(
        :update,
        api: Gateflow.Project.Resources,
        forms: [
          # For forms over existing data
          children: [
            type: :list,
            as: "form_name",
            data: parent.children,
            resource: Child,
            update_action: :update
          ]
        ]
      )

    socket =
      assign(socket,
        form: form
      )
      |> assign(:parent_id, parent.id)

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
              <%= for child_form <- Phoenix.HTML.Form.inputs_for(f, :children) do %>
                <.input field={{child_form, :name}} type="text" label="Title" />
                <.input field={{child_form, :id}} type="hidden" />
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
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    IO.inspect(form, label: "Form")

    case AshPhoenix.Form.submit(form) do
      {:ok, result} ->
        {:noreply, push_navigate(socket, to: "/simpleform/#{socket.assigns.parent_id}")}

      {:error, form} ->
        assign(socket, :form, form)
    end
  end
end
