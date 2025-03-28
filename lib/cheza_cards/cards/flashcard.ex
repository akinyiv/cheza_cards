defmodule ChezaCards.Cards.Flashcard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flashcards" do
    field :question, :string
    field :answer, :string
    field :hint, :string
    field :tags, {:array, :string}, default: []
    
    belongs_to :collection, ChezaCards.Cards.Collection
    belongs_to :user, ChezaCards.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(flashcard, attrs) do
    flashcard
    |> cast(attrs, [:question, :answer, :hint, :tags, :collection_id, :user_id])
    |> validate_required([:question, :answer, :collection_id, :user_id])
    |> validate_length(:question, min: 3, max: 1000)
    |> validate_length(:answer, min: 1, max: 1000)
    |> validate_length(:hint, max: 500)
    |> foreign_key_constraint(:collection_id)
    |> foreign_key_constraint(:user_id)
  end
end
