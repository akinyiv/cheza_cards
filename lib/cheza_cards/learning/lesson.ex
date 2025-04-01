defmodule ChezaCards.Learning.Lesson do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lessons" do
    field :name, :string
    field :description, :string
    field :content, :string
    field :order, :integer
    field :metadata, :map, default: %{}

    belongs_to :module, ChezaCards.Learning.Module
    has_many :user_progress, ChezaCards.Learning.UserProgress

    timestamps()
  end

  @doc false
  def changeset(lesson, attrs) do
    lesson
    |> cast(attrs, [:name, :description, :content, :order, :module_id, :metadata])
    |> validate_required([:name, :content, :module_id])
    |> foreign_key_constraint(:module_id)
  end
end
