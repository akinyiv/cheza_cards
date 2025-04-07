defmodule ChezaCards.Repo.Migrations.AddProfileFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :avatar_url, :string
    end
  end
end