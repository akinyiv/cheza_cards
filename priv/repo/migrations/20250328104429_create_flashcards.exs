defmodule ChezaCards.Repo.Migrations.CreateFlashcards do
  use Ecto.Migration

  def change do
    create table(:flashcards) do
      add :question, :string
      add :answer, :string
      add :hint, :string
      add :tags, {:array, :string}
      add :collection_id, references(:collections, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:flashcards, [:collection_id])
    create index(:flashcards, [:user_id])
  end
end
