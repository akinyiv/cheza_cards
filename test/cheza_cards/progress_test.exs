defmodule ChezaCards.ProgressTest do
  use ChezaCards.DataCase

  alias ChezaCards.Progress

  describe "user_progress" do
    alias ChezaCards.Progress.UserProgress

    import ChezaCards.ProgressFixtures

    @invalid_attrs %{level: nil, streak_count: nil, total_stars: nil, last_activity: nil}

    test "list_user_progress/0 returns all user_progress" do
      user_progress = user_progress_fixture()
      assert Progress.list_user_progress() == [user_progress]
    end

    test "get_user_progress!/1 returns the user_progress with given id" do
      user_progress = user_progress_fixture()
      assert Progress.get_user_progress!(user_progress.id) == user_progress
    end

    test "create_user_progress/1 with valid data creates a user_progress" do
      valid_attrs = %{level: 42, streak_count: 42, total_stars: 42, last_activity: ~U[2025-03-27 10:46:00Z]}

      assert {:ok, %UserProgress{} = user_progress} = Progress.create_user_progress(valid_attrs)
      assert user_progress.level == 42
      assert user_progress.streak_count == 42
      assert user_progress.total_stars == 42
      assert user_progress.last_activity == ~U[2025-03-27 10:46:00Z]
    end

    test "create_user_progress/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Progress.create_user_progress(@invalid_attrs)
    end

    test "update_user_progress/2 with valid data updates the user_progress" do
      user_progress = user_progress_fixture()
      update_attrs = %{level: 43, streak_count: 43, total_stars: 43, last_activity: ~U[2025-03-28 10:46:00Z]}

      assert {:ok, %UserProgress{} = user_progress} = Progress.update_user_progress(user_progress, update_attrs)
      assert user_progress.level == 43
      assert user_progress.streak_count == 43
      assert user_progress.total_stars == 43
      assert user_progress.last_activity == ~U[2025-03-28 10:46:00Z]
    end

    test "update_user_progress/2 with invalid data returns error changeset" do
      user_progress = user_progress_fixture()
      assert {:error, %Ecto.Changeset{}} = Progress.update_user_progress(user_progress, @invalid_attrs)
      assert user_progress == Progress.get_user_progress!(user_progress.id)
    end

    test "delete_user_progress/1 deletes the user_progress" do
      user_progress = user_progress_fixture()
      assert {:ok, %UserProgress{}} = Progress.delete_user_progress(user_progress)
      assert_raise Ecto.NoResultsError, fn -> Progress.get_user_progress!(user_progress.id) end
    end

    test "change_user_progress/1 returns a user_progress changeset" do
      user_progress = user_progress_fixture()
      assert %Ecto.Changeset{} = Progress.change_user_progress(user_progress)
    end
  end

  describe "achievements" do
    alias ChezaCards.Progress.Achievement

    import ChezaCards.ProgressFixtures

    @invalid_attrs %{name: nil, description: nil, badge_icon: nil, required_score: nil}

    test "list_achievements/0 returns all achievements" do
      achievement = achievement_fixture()
      assert Progress.list_achievements() == [achievement]
    end

    test "get_achievement!/1 returns the achievement with given id" do
      achievement = achievement_fixture()
      assert Progress.get_achievement!(achievement.id) == achievement
    end

    test "create_achievement/1 with valid data creates a achievement" do
      valid_attrs = %{name: "some name", description: "some description", badge_icon: "some badge_icon", required_score: 42}

      assert {:ok, %Achievement{} = achievement} = Progress.create_achievement(valid_attrs)
      assert achievement.name == "some name"
      assert achievement.description == "some description"
      assert achievement.badge_icon == "some badge_icon"
      assert achievement.required_score == 42
    end

    test "create_achievement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Progress.create_achievement(@invalid_attrs)
    end

    test "update_achievement/2 with valid data updates the achievement" do
      achievement = achievement_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", badge_icon: "some updated badge_icon", required_score: 43}

      assert {:ok, %Achievement{} = achievement} = Progress.update_achievement(achievement, update_attrs)
      assert achievement.name == "some updated name"
      assert achievement.description == "some updated description"
      assert achievement.badge_icon == "some updated badge_icon"
      assert achievement.required_score == 43
    end

    test "update_achievement/2 with invalid data returns error changeset" do
      achievement = achievement_fixture()
      assert {:error, %Ecto.Changeset{}} = Progress.update_achievement(achievement, @invalid_attrs)
      assert achievement == Progress.get_achievement!(achievement.id)
    end

    test "delete_achievement/1 deletes the achievement" do
      achievement = achievement_fixture()
      assert {:ok, %Achievement{}} = Progress.delete_achievement(achievement)
      assert_raise Ecto.NoResultsError, fn -> Progress.get_achievement!(achievement.id) end
    end

    test "change_achievement/1 returns a achievement changeset" do
      achievement = achievement_fixture()
      assert %Ecto.Changeset{} = Progress.change_achievement(achievement)
    end
  end
end
