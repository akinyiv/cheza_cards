defmodule ChezaCards.Repo.Migrations.CreateLearningTracks do
  use Ecto.Migration

  def change do
    create table(:learning_tracks) do
      add :name, :string, null: false
      add :description, :text
      add :slug, :string, null: false
      add :icon, :string
      add :order, :integer
      add :is_active, :boolean, default: true
      add :is_featured, :boolean, default: false
      add :metadata, :map

      timestamps()
    end

    create unique_index(:learning_tracks, [:slug])

    create table(:modules) do
      add :name, :string, null: false
      add :description, :text
      add :slug, :string, null: false
      add :order, :integer
      add :track_id, references(:learning_tracks, on_delete: :delete_all), null: false
      add :estimated_time, :integer # in minutes
      add :difficulty_level, :string
      add :prerequisites, {:array, :string}
      add :learning_objectives, {:array, :string}
      add :metadata, :map

      timestamps()
    end

    create index(:modules, [:track_id])
    create unique_index(:modules, [:track_id, :slug])

    create table(:lessons) do
      add :title, :string, null: false
      add :content, :text
      add :order, :integer
      add :module_id, references(:modules, on_delete: :delete_all), null: false
      add :lesson_type, :string # video, text, quiz, flashcards, etc.
      add :estimated_time, :integer # in minutes
      add :metadata, :map

      timestamps()
    end

    create index(:lessons, [:module_id])
  end
end
