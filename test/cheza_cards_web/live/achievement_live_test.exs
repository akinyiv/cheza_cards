defmodule ChezaCardsWeb.AchievementLiveTest do
  use ChezaCardsWeb.ConnCase

  import Phoenix.LiveViewTest
  import ChezaCards.ProgressFixtures

  @create_attrs %{name: "some name", description: "some description", badge_icon: "some badge_icon", required_score: 42}
  @update_attrs %{name: "some updated name", description: "some updated description", badge_icon: "some updated badge_icon", required_score: 43}
  @invalid_attrs %{name: nil, description: nil, badge_icon: nil, required_score: nil}

  defp create_achievement(_) do
    achievement = achievement_fixture()
    %{achievement: achievement}
  end

  describe "Index" do
    setup [:create_achievement]

    test "lists all achievements", %{conn: conn, achievement: achievement} do
      {:ok, _index_live, html} = live(conn, ~p"/achievements")

      assert html =~ "Listing Achievements"
      assert html =~ achievement.name
    end

    test "saves new achievement", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/achievements")

      assert index_live |> element("a", "New Achievement") |> render_click() =~
               "New Achievement"

      assert_patch(index_live, ~p"/achievements/new")

      assert index_live
             |> form("#achievement-form", achievement: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#achievement-form", achievement: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/achievements")

      html = render(index_live)
      assert html =~ "Achievement created successfully"
      assert html =~ "some name"
    end

    test "updates achievement in listing", %{conn: conn, achievement: achievement} do
      {:ok, index_live, _html} = live(conn, ~p"/achievements")

      assert index_live |> element("#achievements-#{achievement.id} a", "Edit") |> render_click() =~
               "Edit Achievement"

      assert_patch(index_live, ~p"/achievements/#{achievement}/edit")

      assert index_live
             |> form("#achievement-form", achievement: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#achievement-form", achievement: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/achievements")

      html = render(index_live)
      assert html =~ "Achievement updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes achievement in listing", %{conn: conn, achievement: achievement} do
      {:ok, index_live, _html} = live(conn, ~p"/achievements")

      assert index_live |> element("#achievements-#{achievement.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#achievements-#{achievement.id}")
    end
  end

  describe "Show" do
    setup [:create_achievement]

    test "displays achievement", %{conn: conn, achievement: achievement} do
      {:ok, _show_live, html} = live(conn, ~p"/achievements/#{achievement}")

      assert html =~ "Show Achievement"
      assert html =~ achievement.name
    end

    test "updates achievement within modal", %{conn: conn, achievement: achievement} do
      {:ok, show_live, _html} = live(conn, ~p"/achievements/#{achievement}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Achievement"

      assert_patch(show_live, ~p"/achievements/#{achievement}/show/edit")

      assert show_live
             |> form("#achievement-form", achievement: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#achievement-form", achievement: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/achievements/#{achievement}")

      html = render(show_live)
      assert html =~ "Achievement updated successfully"
      assert html =~ "some updated name"
    end
  end
end
