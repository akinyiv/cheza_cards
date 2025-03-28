defmodule ChezaCards.Repo.Migrations.CreateUserAchievements do
  use Ecto.Migration

  def change do
    create table(:user_achievements) do
      add :earned_at, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)
      add :achievement_id, references(:achievements, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:user_achievements, [:user_id])
    create index(:user_achievements, [:achievement_id])
  end
end
