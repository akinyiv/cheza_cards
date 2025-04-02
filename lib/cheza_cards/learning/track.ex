defmodule ChezaCards.Learning.Track do
  use Ecto.Schema
  import Ecto.Changeset

  schema "learning_tracks" do
    field :name, :string
    field :description, :string
    field :is_featured, :boolean, default: false
    field :subject, :string
    field :grade_level, :integer
    field :image_url, :string

    has_many :modules, ChezaCards.Learning.Module
    has_many :user_progress, ChezaCards.Learning.UserProgress

    timestamps()
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [:name, :description, :is_featured, :subject, :grade_level, :image_url])
    |> validate_required([:name, :description, :subject, :grade_level])
  end
end
