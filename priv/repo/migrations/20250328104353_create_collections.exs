defmodule ChezaCards.Repo.Migrations.CreateCollections do
  use Ecto.Migration

  def change do
    create table(:collections) do
      add :name, :string
      add :description, :string
      add :is_public, :boolean, default: false
      add :is_premium, :boolean, default: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:collections, [:user_id])
  end
end
