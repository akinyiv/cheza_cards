defmodule ChezaCards.Learning do
  @moduledoc """
  The Learning context manages the learning content system, including tracks,
  modules, lessons, and user progress tracking.
  """

  import Ecto.Query, warn: false
  alias ChezaCards.Repo

  alias ChezaCards.Learning.{Track, Module, Lesson, UserProgress}

  @doc """
  Returns the list of learning tracks.
  """
  def list_tracks do
    Track
    |> order_by(asc: :order)
    |> Repo.all()
  end

  @doc """
  Returns a list of featured tracks for the dashboard.
  """
  def list_featured_tracks do
    Track
    |> where(is_active: true, is_featured: true)
    |> order_by(asc: :order)
    |> Repo.all()
  end

  @doc """
  Gets a single track.
  Raises `Ecto.NoResultsError` if the Track does not exist.
  """
  def get_track!(id), do: Repo.get!(Track, id)

  @doc """
  Gets a track by its slug.
  Returns nil if no track is found.
  """
  def get_track_by_slug(slug) do
    Repo.get_by(Track, slug: slug)
  end

  @doc """
  Creates a track.
  """
  def create_track(attrs \\ %{}) do
    %Track{}
    |> Track.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a track.
  """
  def update_track(%Track{} = track, attrs) do
    track
    |> Track.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a track.
  """
  def delete_track(%Track{} = track) do
    Repo.delete(track)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking track changes.
  """
  def change_track(%Track{} = track, attrs \\ %{}) do
    Track.changeset(track, attrs)
  end

  # Module functions

  @doc """
  Returns the list of modules for a track.
  """
  def list_modules(%Track{} = track) do
    Module
    |> where(track_id: ^track.id)
    |> order_by(asc: :order)
    |> Repo.all()
  end

  @doc """
  Gets a single module.
  Raises `Ecto.NoResultsError` if the Module does not exist.
  """
  def get_module!(id), do: Repo.get!(Module, id)

  @doc """
  Gets a module by its slug within a track.
  Returns nil if no module is found.
  """
  def get_module_by_slug(track_id, slug) do
    Repo.get_by(Module, track_id: track_id, slug: slug)
  end

  @doc """
  Creates a module.
  """
  def create_module(attrs \\ %{}) do
    %Module{}
    |> Module.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a module.
  """
  def update_module(%Module{} = module, attrs) do
    module
    |> Module.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a module.
  """
  def delete_module(%Module{} = module) do
    Repo.delete(module)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking module changes.
  """
  def change_module(%Module{} = module, attrs \\ %{}) do
    Module.changeset(module, attrs)
  end

  # Lesson functions

  @doc """
  Returns the list of lessons for a module.
  """
  def list_lessons(%Module{} = module) do
    Lesson
    |> where(module_id: ^module.id)
    |> order_by(asc: :order)
    |> Repo.all()
  end

  @doc """
  Gets a single lesson.
  Raises `Ecto.NoResultsError` if the Lesson does not exist.
  """
  def get_lesson!(id), do: Repo.get!(Lesson, id)

  @doc """
  Creates a lesson.
  """
  def create_lesson(attrs \\ %{}) do
    %Lesson{}
    |> Lesson.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lesson.
  """
  def update_lesson(%Lesson{} = lesson, attrs) do
    lesson
    |> Lesson.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a lesson.
  """
  def delete_lesson(%Lesson{} = lesson) do
    Repo.delete(lesson)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lesson changes.
  """
  def change_lesson(%Lesson{} = lesson, attrs \\ %{}) do
    Lesson.changeset(lesson, attrs)
  end

  # User Progress functions

  @doc """
  Gets a user's progress for a specific track.
  """
  def get_user_track_progress(user_id, track_id) do
    UserProgress
    |> where(user_id: ^user_id, track_id: ^track_id)
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  @doc """
  Gets a user's progress for a specific lesson.
  """
  def get_user_lesson_progress(user_id, lesson_id) do
    UserProgress
    |> where(user_id: ^user_id, lesson_id: ^lesson_id)
    |> Repo.one()
  end

  @doc """
  Updates or creates user progress for a lesson.
  """
  def update_user_lesson_progress(user_id, lesson_id, attrs) do
    case get_user_lesson_progress(user_id, lesson_id) do
      nil ->
        create_user_progress(Map.merge(attrs, %{user_id: user_id, lesson_id: lesson_id}))

      progress ->
        update_user_progress(progress, attrs)
    end
  end

  @doc """
  Creates user progress.
  """
  def create_user_progress(attrs \\ %{}) do
    %UserProgress{}
    |> UserProgress.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates user progress.
  """
  def update_user_progress(%UserProgress{} = progress, attrs) do
    progress
    |> UserProgress.changeset(attrs)
    |> Repo.update()
  end
end
