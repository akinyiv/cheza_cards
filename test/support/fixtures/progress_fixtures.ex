defmodule ChezaCards.ProgressFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChezaCards.Progress` context.
  """

  @doc """
  Generate a user_progress.
  """
  def user_progress_fixture(attrs \\ %{}) do
    {:ok, user_progress} =
      attrs
      |> Enum.into(%{
        last_activity: ~U[2025-03-27 10:46:00Z],
        level: 42,
        streak_count: 42,
        total_stars: 42
      })
      |> ChezaCards.Progress.create_user_progress()

    user_progress
  end

  @doc """
  Generate a achievement.
  """
  def achievement_fixture(attrs \\ %{}) do
    {:ok, achievement} =
      attrs
      |> Enum.into(%{
        badge_icon: "some badge_icon",
        description: "some description",
        name: "some name",
        required_score: 42
      })
      |> ChezaCards.Progress.create_achievement()

    achievement
  end
end
