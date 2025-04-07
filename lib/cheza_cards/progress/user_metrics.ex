defmodule ChezaCards.Progress.UserMetrics do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_metrics" do
    field :streak_count, :integer, default: 0
    field :total_stars, :integer, default: 0
    field :level, :integer, default: 1
    field :last_activity, :utc_datetime

    belongs_to :user, ChezaCards.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(user_metrics, attrs) do
    user_metrics
    |> cast(attrs, [:streak_count, :total_stars, :level, :last_activity, :user_id])
    |> validate_required([:user_id])
    |> validate_number(:streak_count, greater_than_or_equal_to: 0)
    |> validate_number(:total_stars, greater_than_or_equal_to: 0)
    |> validate_number(:level, greater_than_or_equal_to: 1)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id)
  end
end
