defmodule ChezaCardsWeb.Router do
  use ChezaCardsWeb, :router

  import ChezaCardsWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ChezaCardsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChezaCardsWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{ChezaCardsWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", ChezaCardsWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{ChezaCardsWeb.UserAuth, :ensure_authenticated}] do
      # Main dashboard route
      live "/dashboard", DashboardLive, :index
      
      # Learning paths and tracks
      live "/learn", LearnLive.Index, :index
      live "/learn/:track", LearnLive.Track, :show
      live "/learn/:track/:module", LearnLive.Module, :show
      
      # Collections and Flashcards
      live "/collections", CollectionLive.Index, :index
      live "/collections/new", CollectionLive.Index, :new
      live "/collections/:id/edit", CollectionLive.Index, :edit
      live "/collections/:id", CollectionLive.Show, :show
      live "/collections/:id/show/edit", CollectionLive.Show, :edit

      # User settings and profile
      live "/profile", UserProfileLive, :show
      live "/profile/settings", UserSettingsLive, :edit
      live "/profile/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/admin", ChezaCardsWeb.Admin do
    pipe_through [:browser, :require_authenticated_user, :require_admin_user]

    live_session :require_admin_user,
      on_mount: [{ChezaCardsWeb.UserAuth, :ensure_admin_user}] do
      live "/", AdminDashboardLive, :index
      
      # Learning content management
      live "/tracks", TrackLive.Index, :index
      live "/tracks/new", TrackLive.Index, :new
      live "/tracks/:id/edit", TrackLive.Index, :edit
      live "/tracks/:id/modules", ModuleLive.Index, :index
      live "/tracks/:id/modules/new", ModuleLive.Index, :new
      live "/tracks/:id/modules/:module_id/edit", ModuleLive.Index, :edit
      live "/tracks/:id/modules/:module_id/lessons", LessonLive.Index, :index
      live "/tracks/:id/modules/:module_id/lessons/new", LessonLive.Index, :new
      live "/tracks/:id/modules/:module_id/lessons/:lesson_id/edit", LessonLive.Index, :edit
      
      # Content import/export
      live "/import", ImportLive, :index
      live "/export", ExportLive, :index
      
      # Analytics and reports
      live "/analytics", AnalyticsLive, :index
      live "/reports", ReportLive, :index
    end
  end

  scope "/", ChezaCardsWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{ChezaCardsWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Mix.env() == :dev do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ChezaCardsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
