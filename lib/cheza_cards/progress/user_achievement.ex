defmodule ChezaCards.Progress.UserAchievement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_achievements" do
    field :earned_at, :utc_datetime
    
    belongs_to :user, ChezaCards.Accounts.User
    belongs_to :achievement, ChezaCards.Progress.Achievement

    timestamps()
  end

  @doc false
  def changeset(user_achievement, attrs) do
    user_achievement
    |> cast(attrs, [:earned_at, :user_id, :achievement_id])
    |> validate_required([:earned_at, :user_id, :achievement_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:achievement_id)
    |> unique_constraint([:user_id, :achievement_id], name: :user_achievements_user_id_achievement_id_index)
  end
end
