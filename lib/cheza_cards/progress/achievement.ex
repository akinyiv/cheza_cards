defmodule ChezaCards.Progress.Achievement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "achievements" do
    field :name, :string
    field :description, :string
    field :badge_icon, :string
    field :required_score, :integer
    
    has_many :user_achievements, ChezaCards.Progress.UserAchievement
    has_many :users, through: [:user_achievements, :user]

    timestamps()
  end

  @doc false
  def changeset(achievement, attrs) do
    achievement
    |> cast(attrs, [:name, :description, :badge_icon, :required_score])
    |> validate_required([:name, :description, :badge_icon, :required_score])
    |> validate_length(:name, min: 3, max: 100)
    |> validate_length(:description, min: 10, max: 500)
    |> validate_length(:badge_icon, min: 1, max: 100)
    |> validate_number(:required_score, greater_than: 0)
  end
end
