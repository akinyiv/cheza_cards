defmodule ChezaCards.Learning.Module do
  use Ecto.Schema
  import Ecto.Changeset

  schema "modules" do
    field :name, :string
    field :description, :string
    field :slug, :string
    field :order, :integer
    field :metadata, :map, default: %{}

    belongs_to :track, ChezaCards.Learning.Track
    has_many :lessons, ChezaCards.Learning.Lesson
    has_many :user_progress, ChezaCards.Learning.UserProgress

    timestamps()
  end

  @doc false
  def changeset(module, attrs) do
    module
    |> cast(attrs, [:name, :description, :slug, :order, :track_id, :metadata])
    |> validate_required([:name, :slug, :track_id])
    |> unique_constraint([:track_id, :slug])
    |> validate_format(:slug, ~r/^[a-z0-9-]+$/, message: "must contain only lowercase letters, numbers, and dashes")
    |> foreign_key_constraint(:track_id)
  end
end
