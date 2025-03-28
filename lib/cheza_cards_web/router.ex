defmodule ChezaCardsWeb.Router do
  use ChezaCardsWeb, :router


  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ChezaCardsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChezaCardsWeb do
    pipe_through :browser

    live "/", PageLive, :home

    live "/collections", CollectionLive.Index, :index
    live "/collections/new", CollectionLive.Index, :new
    live "/collections/:id/edit", CollectionLive.Index, :edit
    live "/collections/:id", CollectionLive.Show, :show
    live "/collections/:id/show/edit", CollectionLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChezaCardsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:cheza_cards, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ChezaCardsWeb.Telemetry
    end
  end
end
