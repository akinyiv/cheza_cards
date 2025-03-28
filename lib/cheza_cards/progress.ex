defmodule ChezaCards.Progress do
  @moduledoc """
  The Progress context.
  """

  import Ecto.Query, warn: false
  alias ChezaCards.Repo

  alias ChezaCards.Progress.UserProgress

  @doc """
  Returns the list of user_progress.

  ## Examples

      iex> list_user_progress()
      [%UserProgress{}, ...]

  """
  def list_user_progress do
    Repo.all(UserProgress)
  end

  @doc """
  Gets a single user_progress.

  Raises `Ecto.NoResultsError` if the User progress does not exist.

  ## Examples

      iex> get_user_progress!(123)
      %UserProgress{}

      iex> get_user_progress!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_progress!(id), do: Repo.get!(UserProgress, id)

  @doc """
  Creates a user_progress.

  ## Examples

      iex> create_user_progress(%{field: value})
      {:ok, %UserProgress{}}

      iex> create_user_progress(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_progress(attrs \\ %{}) do
    %UserProgress{}
    |> UserProgress.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_progress.

  ## Examples

      iex> update_user_progress(user_progress, %{field: new_value})
      {:ok, %UserProgress{}}

      iex> update_user_progress(user_progress, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_progress(%UserProgress{} = user_progress, attrs) do
    user_progress
    |> UserProgress.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_progress.

  ## Examples

      iex> delete_user_progress(user_progress)
      {:ok, %UserProgress{}}

      iex> delete_user_progress(user_progress)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_progress(%UserProgress{} = user_progress) do
    Repo.delete(user_progress)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_progress changes.

  ## Examples

      iex> change_user_progress(user_progress)
      %Ecto.Changeset{data: %UserProgress{}}

  """
  def change_user_progress(%UserProgress{} = user_progress, attrs \\ %{}) do
    UserProgress.changeset(user_progress, attrs)
  end

  alias ChezaCards.Progress.Achievement

  @doc """
  Returns the list of achievements.

  ## Examples

      iex> list_achievements()
      [%Achievement{}, ...]

  """
  def list_achievements do
    Repo.all(Achievement)
  end

  @doc """
  Gets a single achievement.

  Raises `Ecto.NoResultsError` if the Achievement does not exist.

  ## Examples

      iex> get_achievement!(123)
      %Achievement{}

      iex> get_achievement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_achievement!(id), do: Repo.get!(Achievement, id)

  @doc """
  Creates a achievement.

  ## Examples

      iex> create_achievement(%{field: value})
      {:ok, %Achievement{}}

      iex> create_achievement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_achievement(attrs \\ %{}) do
    %Achievement{}
    |> Achievement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a achievement.

  ## Examples

      iex> update_achievement(achievement, %{field: new_value})
      {:ok, %Achievement{}}

      iex> update_achievement(achievement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_achievement(%Achievement{} = achievement, attrs) do
    achievement
    |> Achievement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a achievement.

  ## Examples

      iex> delete_achievement(achievement)
      {:ok, %Achievement{}}

      iex> delete_achievement(achievement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_achievement(%Achievement{} = achievement) do
    Repo.delete(achievement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking achievement changes.

  ## Examples

      iex> change_achievement(achievement)
      %Ecto.Changeset{data: %Achievement{}}

  """
  def change_achievement(%Achievement{} = achievement, attrs \\ %{}) do
    Achievement.changeset(achievement, attrs)
  end
end
