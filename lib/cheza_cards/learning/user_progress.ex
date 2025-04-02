defmodule ChezaCards.Learning.UserProgress do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_progress" do
    field :status, :string # not_started, in_progress, completed
    field :progress_data, :map, default: %{}
    field :completed_at, :utc_datetime

    belongs_to :user, ChezaCards.Accounts.User
    belongs_to :track, ChezaCards.Learning.Track
    belongs_to :module, ChezaCards.Learning.Module
    belongs_to :lesson, ChezaCards.Learning.Lesson

    timestamps()
  end

  @doc false
  def changeset(user_progress, attrs) do
    user_progress
    |> cast(attrs, [:user_id, :track_id, :module_id, :lesson_id, :status, :progress_data, :completed_at])
    |> validate_required([:user_id, :status])
    |> validate_inclusion(:status, ["not_started", "in_progress", "completed"])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:track_id)
    |> foreign_key_constraint(:module_id)
    |> foreign_key_constraint(:lesson_id)
  end
end
