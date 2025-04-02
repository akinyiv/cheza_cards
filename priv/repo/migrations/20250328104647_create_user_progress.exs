defmodule ChezaCards.Repo.Migrations.CreateUserProgress do
  use Ecto.Migration

  def change do
    create table(:user_progress) do
      add :status, :string
      add :progress_data, :map
      add :completed_at, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :track_id, references(:learning_tracks, on_delete: :delete_all)
      add :module_id, references(:modules, on_delete: :delete_all)
      add :lesson_id, references(:lessons, on_delete: :delete_all)

      timestamps()
    end

    create index(:user_progress, [:user_id])
    create index(:user_progress, [:track_id])
    create index(:user_progress, [:module_id])
    create index(:user_progress, [:lesson_id])
  end
end
