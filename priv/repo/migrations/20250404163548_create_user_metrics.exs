defmodule ChezaCards.Repo.Migrations.CreateUserMetrics do
  use Ecto.Migration

  def change do
    create table(:user_metrics) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :streak_count, :integer, default: 0
      add :total_stars, :integer, default: 0
      add :level, :integer, default: 1
      add :last_activity, :utc_datetime

      timestamps()
    end

    create unique_index(:user_metrics, [:user_id])
  end
end
