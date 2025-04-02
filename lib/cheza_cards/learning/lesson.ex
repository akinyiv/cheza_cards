defmodule ChezaCards.Learning.Lesson do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lessons" do
    field :name, :string
    field :description, :string
    field :content, :map
    field :order, :integer
    field :duration_minutes, :integer
    field :points, :integer, default: 10
    field :image_url, :string

    belongs_to :module, ChezaCards.Learning.Module
    belongs_to :track, ChezaCards.Learning.Track
    has_many :user_progress, ChezaCards.Learning.UserProgress

    timestamps()
  end

  @doc false
  def changeset(lesson, attrs) do
    lesson
    |> cast(attrs, [:name, :description, :content, :order, :duration_minutes, :points, :image_url, :module_id, :track_id])
    |> validate_required([:name, :description, :content, :module_id, :track_id])
    |> foreign_key_constraint(:module_id)
    |> foreign_key_constraint(:track_id)
  end
end
