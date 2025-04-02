defmodule ChezaCards.Learning do
  @moduledoc """
  The Learning context.
  """

  import Ecto.Query, warn: false
  alias ChezaCards.Repo

  alias ChezaCards.Learning.{Track, Module, Lesson, UserProgress}
  alias ChezaCards.Accounts.User

  @doc """
  Returns the list of featured tracks.
  """
  def list_featured_tracks do
    Track
    |> where([t], t.is_featured == true)
    |> preload([:modules])
    |> Repo.all()
  end

  @doc """
  Returns the list of tracks.
  """
  def list_tracks do
    Track
    |> preload([:modules])
    |> Repo.all()
  end

  @doc """
  Returns a user's recent progress across all tracks and lessons.
  """
  def get_recent_progress(%User{} = user) do
    UserProgress
    |> where(user_id: ^user.id)
    |> order_by(desc: :updated_at)
    |> limit(5)
    |> preload([:track, :module, :lesson])
    |> Repo.all()
  end

  @doc """
  Gets a single track.
  """
  def get_track!(id) do
    Track
    |> preload([:modules])
    |> Repo.get!(id)
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

  @doc """
  Returns the list of modules for a track.
  """
  def list_modules(%Track{} = track) do
    Module
    |> where(track_id: ^track.id)
    |> preload([:lessons])
    |> Repo.all()
  end

  @doc """
  Gets a single module.
  """
  def get_module!(id) do
    Module
    |> preload([:lessons])
    |> Repo.get!(id)
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
  Returns the list of lessons for a module.
  """
  def list_lessons(%Module{} = module) do
    Lesson
    |> where(module_id: ^module.id)
    |> Repo.all()
  end

  @doc """
  Gets a single lesson.
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
  Updates a user's progress for a lesson.
  """
  def update_user_progress(%User{} = user, %Lesson{} = lesson, attrs) do
    progress =
      UserProgress
      |> where(user_id: ^user.id, lesson_id: ^lesson.id)
      |> Repo.one() ||
        %UserProgress{
          user_id: user.id,
          lesson_id: lesson.id,
          module_id: lesson.module_id,
          track_id: lesson.track_id
        }

    progress
    |> UserProgress.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @doc """
  Gets a user's progress for a lesson.
  """
  def get_user_lesson_progress(%User{} = user, %Lesson{} = lesson) do
    UserProgress
    |> where(user_id: ^user.id, lesson_id: ^lesson.id)
    |> Repo.one()
  end

  @doc """
  Gets a user's progress for a module.
  """
  def get_user_module_progress(%User{} = user, %Module{} = module) do
    UserProgress
    |> where(user_id: ^user.id, module_id: ^module.id)
    |> Repo.all()
  end

  @doc """
  Gets a user's progress for a track.
  """
  def get_user_track_progress(%User{} = user, %Track{} = track) do
    UserProgress
    |> where(user_id: ^user.id, track_id: ^track.id)
    |> Repo.all()
  end
end
