defmodule ChezaCards.Learning.Module do
  use Ecto.Schema
  import Ecto.Changeset

  schema "modules" do
    field :name, :string
    field :description, :string
    field :order, :integer
    field :image_url, :string

    belongs_to :track, ChezaCards.Learning.Track
    has_many :lessons, ChezaCards.Learning.Lesson
    has_many :user_progress, ChezaCards.Learning.UserProgress

    timestamps()
  end

  @doc false
  def changeset(module, attrs) do
    module
    |> cast(attrs, [:name, :description, :order, :image_url, :track_id])
    |> validate_required([:name, :description, :track_id])
    |> foreign_key_constraint(:track_id)
  end
end
