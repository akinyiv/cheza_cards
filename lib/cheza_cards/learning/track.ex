defmodule ChezaCards.Learning.Track do
  use Ecto.Schema
  import Ecto.Changeset

  schema "learning_tracks" do
    field :name, :string
    field :description, :string
    field :slug, :string
    field :icon, :string
    field :order, :integer
    field :is_active, :boolean, default: true
    field :is_featured, :boolean, default: false
    field :metadata, :map, default: %{}

    has_many :modules, ChezaCards.Learning.Module
    has_many :user_progress, ChezaCards.Learning.UserProgress

    timestamps()
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [:name, :description, :slug, :icon, :order, :is_active, :is_featured, :metadata])
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
    |> validate_format(:slug, ~r/^[a-z0-9-]+$/, message: "must contain only lowercase letters, numbers, and dashes")
  end
end
