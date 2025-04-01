defmodule ChezaCards.Cards do
  @moduledoc """
  The Cards context.
  """

  import Ecto.Query, warn: false
  alias ChezaCards.Repo

  alias ChezaCards.Cards.{Collection, Flashcard}
  alias ChezaCards.Accounts.User

  @doc """
  Returns the list of collections.

  ## Examples

      iex> list_collections()
      [%Collection{}, ...]

  """
  def list_collections do
    Repo.all(Collection)
  end

  @doc """
  Returns the list of recent collections for a user.

  ## Examples

      iex> list_recent_collections(user, 5)
      [%Collection{}, ...]

  """
  def list_recent_collections(%User{} = user, limit \\ 5) do
    Collection
    |> where([c], c.user_id == ^user.id)
    |> order_by([c], desc: c.updated_at)
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Gets a single collection.

  Raises `Ecto.NoResultsError` if the Collection does not exist.

  ## Examples

      iex> get_collection!(123)
      %Collection{}

      iex> get_collection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_collection!(id), do: Repo.get!(Collection, id)

  @doc """
  Creates a collection.

  ## Examples

      iex> create_collection(%{field: value})
      {:ok, %Collection{}}

      iex> create_collection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_collection(attrs \\ %{}) do
    %Collection{}
    |> Collection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a collection.

  ## Examples

      iex> update_collection(collection, %{field: new_value})
      {:ok, %Collection{}}

      iex> update_collection(collection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_collection(%Collection{} = collection, attrs) do
    collection
    |> Collection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a collection.

  ## Examples

      iex> delete_collection(collection)
      {:ok, %Collection{}}

      iex> delete_collection(collection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_collection(%Collection{} = collection) do
    Repo.delete(collection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking collection changes.

  ## Examples

      iex> change_collection(collection)
      %Ecto.Changeset{data: %Collection{}}

  """
  def change_collection(%Collection{} = collection, attrs \\ %{}) do
    Collection.changeset(collection, attrs)
  end

  @doc """
  Returns the list of flashcards.

  ## Examples

      iex> list_flashcards()
      [%Flashcard{}, ...]

  """
  def list_flashcards do
    Repo.all(Flashcard)
  end

  @doc """
  Lists flashcards belonging to a specific collection.

  ## Examples

      iex> list_flashcards_by_collection(collection_id)
      [%Flashcard{}, ...]

  """
  def list_flashcards_by_collection(collection_id) do
    Flashcard
    |> where([f], f.collection_id == ^collection_id)
    |> Repo.all()
  end

  @doc """
  Gets a single flashcard.

  Raises `Ecto.NoResultsError` if the Flashcard does not exist.

  ## Examples

      iex> get_flashcard!(123)
      %Flashcard{}

      iex> get_flashcard!(456)
      ** (Ecto.NoResultsError)

  """
  def get_flashcard!(id), do: Repo.get!(Flashcard, id)

  @doc """
  Creates a flashcard.

  ## Examples

      iex> create_flashcard(%{field: value})
      {:ok, %Flashcard{}}

      iex> create_flashcard(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_flashcard(attrs \\ %{}) do
    %Flashcard{}
    |> Flashcard.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a flashcard.

  ## Examples

      iex> update_flashcard(flashcard, %{field: new_value})
      {:ok, %Flashcard{}}

      iex> update_flashcard(flashcard, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_flashcard(%Flashcard{} = flashcard, attrs) do
    flashcard
    |> Flashcard.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a flashcard.

  ## Examples

      iex> delete_flashcard(flashcard)
      {:ok, %Flashcard{}}

      iex> delete_flashcard(flashcard)
      {:error, %Ecto.Changeset{}}

  """
  def delete_flashcard(%Flashcard{} = flashcard) do
    Repo.delete(flashcard)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking flashcard changes.

  ## Examples

      iex> change_flashcard(flashcard)
      %Ecto.Changeset{data: %Flashcard{}}

  """
  def change_flashcard(%Flashcard{} = flashcard, attrs \\ %{}) do
    Flashcard.changeset(flashcard, attrs)
  end

  @doc """
  Gets random flashcards for a study session.

  ## Examples

      iex> get_random_flashcards(collection_id, 10)
      [%Flashcard{}, ...]

  """
  def get_random_flashcards(collection_id, limit \\ 10) do
    Flashcard
    |> where([f], f.collection_id == ^collection_id)
    |> order_by(fragment("RANDOM()"))
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Tracks flashcard progress.

  ## Examples

      iex> track_flashcard_progress(user_id, flashcard_id, status)
      {:ok, :not_implemented}

  """
  def track_flashcard_progress(_user_id, _flashcard_id, _status) do
    # TODO: Implement progress tracking
    {:ok, :not_implemented}
  end

  @doc """
  Gets user streak.

  ## Examples

      iex> get_user_streak(user_id)
      {:ok, 0}

  """
  def get_user_streak(_user_id) do
    # TODO: Implement streak tracking
    {:ok, 0}
  end

  @doc """
  Gets user XP.

  ## Examples

      iex> get_user_xp(user_id)
      {:ok, 0}

  """
  def get_user_xp(_user_id) do
    # TODO: Implement XP system
    {:ok, 0}
  end

  @doc """
  Creates a collection with pre-set CBC-aligned flashcards.

  ## Examples

      iex> create_preset_collection(user_id, "math_g4")
      {:ok, %Collection{}}

  """
  def create_preset_collection(user_id, subject) do
    ChezaCards.Cards.PresetContent.create_preset_collection(user_id, subject)
  end

  @doc """
  Lists available preset subjects.

  ## Examples

      iex> list_preset_subjects()
      ["math_g4", "science_g4", "swahili_g4"]

  """
  def list_preset_subjects do
    ["math_g4", "science_g4", "swahili_g4"]
  end
end
