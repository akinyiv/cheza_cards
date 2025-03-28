defmodule ChezaCards.Repo.Migrations.CreateUserProgress do
  use Ecto.Migration

  def change do
    create table(:user_progress) do
      add :streak_count, :integer
      add :total_stars, :integer
      add :level, :integer
      add :last_activity, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:user_progress, [:user_id])
  end
end
