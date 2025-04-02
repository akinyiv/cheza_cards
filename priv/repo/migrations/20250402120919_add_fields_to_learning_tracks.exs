defmodule ChezaCards.Repo.Migrations.AddFieldsToLearningTracks do
  use Ecto.Migration

  def change do
    alter table(:learning_tracks) do
      add :subject, :string
      add :grade_level, :integer
      add :image_url, :string
    end

    create index(:learning_tracks, [:subject])
    create index(:learning_tracks, [:grade_level])
  end
end
