defmodule ChezaCards.Progress do
  @moduledoc """
  The Progress context.
  """

  import Ecto.Query, warn: false
  alias ChezaCards.Repo
  alias ChezaCards.Learning.UserProgress
  alias ChezaCards.Progress.UserMetrics
  alias ChezaCards.Progress.Achievement

  @doc """
  Returns the list of user_progress.

  ## Examples

      iex> list_user_progress()
      [%UserMetrics{}, ...]

  """
  def list_user_progress do
    Repo.all(UserMetrics)
  end

  @doc """
  Gets a single user_progress.

  Raises `Ecto.NoResultsError` if the User metrics does not exist.

  ## Examples

      iex> get_user_metrics!(123)
      %UserMetrics{}

      iex> get_user_metrics!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_metrics!(id), do: Repo.get!(UserMetrics, id)

  @doc """
  Creates a user_progress.

  ## Examples

      iex> create_user_metrics(%{field: value})
      {:ok, %UserMetrics{}}

      iex> create_user_metrics(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_metrics(attrs \\ %{}) do
    %UserMetrics{}
    |> UserMetrics.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_progress.

  ## Examples

      iex> update_user_metrics(user_metrics, %{field: new_value})
      {:ok, %UserMetrics{}}

      iex> update_user_metrics(user_metrics, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_metrics(%UserMetrics{} = user_metrics, attrs) do
    user_metrics
    |> UserMetrics.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_metrics.

  ## Examples

      iex> delete_user_metrics(user_metrics)
      {:ok, %UserMetrics{}}

      iex> delete_user_metrics(user_metrics)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_metrics(%UserMetrics{} = user_metrics) do
    Repo.delete(user_metrics)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_metrics changes.

  ## Examples

      iex> change_user_metrics(user_metrics)
      %Ecto.Changeset{data: %UserMetrics{}}

  """
  def change_user_metrics(%UserMetrics{} = user_metrics, attrs \\ %{}) do
    UserMetrics.changeset(user_metrics, attrs)
  end

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

   def compute_progress(user_id) do
    completed_count =
      UserProgress
      |> where([up], up.user_id == ^user_id and up.status == "completed")
      |> select([up], count(up.id))
      |> Repo.one()

    total_lessons =
      UserProgress
      |> where([up], up.user_id == ^user_id)
      |> select([up], count(up.id))
      |> Repo.one()

    metrics =
      UserMetrics
      |> where([um], um.user_id == ^user_id)
      |> Repo.one()

    %{
      completed_lessons: completed_count,
      total_lessons: total_lessons,
      completion_percentage:
        if total_lessons > 0 do
          Float.round((completed_count / total_lessons) * 100, 2)
        else
          0.0
        end,
      streak_count: metrics && metrics.streak_count || 0,
      total_stars: metrics && metrics.total_stars || 0,
      level: metrics && metrics.level || 1,
      last_activity: metrics && metrics.last_activity
    }
  end
end
