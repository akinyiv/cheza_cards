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

  pipeline :admin do
    plug :require_authenticated_user
    plug :require_admin_user
  end

  scope "/", ChezaCardsWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChezaCardsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Mix.env() == :dev do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ChezaCardsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

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
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/collections", CollectionLive.Index, :index
      live "/collections/new", CollectionLive.Index, :new
      live "/collections/:id/edit", CollectionLive.Index, :edit
      live "/collections/:id", CollectionLive.Show, :show
      live "/collections/:id/show/edit", CollectionLive.Show, :edit

      live "/collections/:collection_id/flashcards", FlashcardLive.Index, :index
      live "/collections/:collection_id/flashcards/new", FlashcardLive.Index, :new
      live "/collections/:collection_id/flashcards/:id/edit", FlashcardLive.Index, :edit
      live "/collections/:collection_id/flashcards/:id", FlashcardLive.Show, :show
      live "/collections/:collection_id/flashcards/:id/show/edit", FlashcardLive.Show, :edit

      live "/collections/:collection_id/study", StudyLive.Show, :show
      live "/collections/:collection_id/study/results", StudyLive.Show, :results

      live "/dashboard", DashboardLive, :index
      live "/learn", LearningLive.Index, :index
      live "/learn/:track_id", LearningLive.Track, :show
      live "/learn/:track_id/:module_id", LearningLive.Module, :show
      live "/learn/:track_id/:module_id/:lesson_id", LearningLive.Lesson, :show
      live "/learn/:track_id/:module_id/:lesson_id/study", LearningLive.Study, :show
    end
  end

  scope "/admin", ChezaCardsWeb do
    pipe_through [:browser, :admin]

    live_session :admin,
      on_mount: [{ChezaCardsWeb.UserAuth, :ensure_admin}] do
      live "/tracks", Admin.TrackLive.Index, :index
      live "/tracks/new", Admin.TrackLive.Index, :new
      live "/tracks/:id/edit", Admin.TrackLive.Index, :edit
      live "/tracks/:id", Admin.TrackLive.Show, :show
      live "/tracks/:id/show/edit", Admin.TrackLive.Show, :edit

      live "/tracks/:track_id/modules", Admin.ModuleLive.Index, :index
      live "/tracks/:track_id/modules/new", Admin.ModuleLive.Index, :new
      live "/tracks/:track_id/modules/:id/edit", Admin.ModuleLive.Index, :edit
      live "/tracks/:track_id/modules/:id", Admin.ModuleLive.Show, :show
      live "/tracks/:track_id/modules/:id/show/edit", Admin.ModuleLive.Show, :edit

      live "/tracks/:track_id/modules/:module_id/lessons", Admin.LessonLive.Index, :index
      live "/tracks/:track_id/modules/:module_id/lessons/new", Admin.LessonLive.Index, :new
      live "/tracks/:track_id/modules/:module_id/lessons/:id/edit", Admin.LessonLive.Index, :edit
      live "/tracks/:track_id/modules/:module_id/lessons/:id", Admin.LessonLive.Show, :show
      live "/tracks/:track_id/modules/:module_id/lessons/:id/show/edit", Admin.LessonLive.Show, :edit
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
end
