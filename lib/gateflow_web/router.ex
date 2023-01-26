defmodule GateflowWeb.Router do
  use GateflowWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GateflowWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  import AshAdmin.Router
  admin_browser_pipeline(:browser)

  pipeline :api do
    plug :accepts, ["json"]
  end

  # scope "/", GateflowWeb do
  #   pipe_through :browser

  #   get "/", PageController, :home
  # end

  scope "/" do
    # Pipe it through your browser pipeline
    pipe_through [:browser]

    ash_admin("/admin")
    get "/", GateflowWeb.PageController, :home
    live "/board/:board_id", GateflowWeb.BoardLive.Index, :index
    live "/live/graph", GateflowWeb.GraphLive.Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", GateflowWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:gateflow, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GateflowWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
