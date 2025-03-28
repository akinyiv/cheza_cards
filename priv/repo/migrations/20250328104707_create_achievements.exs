defmodule ChezaCards.Repo.Migrations.CreateAchievements do
  use Ecto.Migration

  def change do
    create table(:achievements) do
      add :name, :string
      add :description, :text
      add :badge_icon, :string
      add :required_score, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
