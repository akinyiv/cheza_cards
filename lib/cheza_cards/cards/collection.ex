defmodule ChezaCards.Cards.Collection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "collections" do
    field :name, :string
    field :description, :string
    field :is_public, :boolean, default: false
    field :is_premium, :boolean, default: false
    
    belongs_to :user, ChezaCards.Accounts.User
    has_many :flashcards, ChezaCards.Cards.Flashcard

    timestamps()
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:name, :description, :is_public, :is_premium, :user_id])
    |> validate_required([:name, :description, :is_public, :is_premium, :user_id])
    |> validate_length(:name, min: 3, max: 100)
    |> validate_length(:description, max: 1000)
    |> foreign_key_constraint(:user_id)
  end
end
