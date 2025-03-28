defmodule ChezaCards.Cards do
  @moduledoc """
  The Cards context.
  """

  import Ecto.Query, warn: false
  alias ChezaCards.Repo

  alias ChezaCards.Cards.Collection
  alias ChezaCards.Cards.Flashcard

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
end
