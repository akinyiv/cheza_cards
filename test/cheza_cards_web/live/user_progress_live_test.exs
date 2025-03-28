defmodule ChezaCardsWeb.UserProgressLiveTest do
  use ChezaCardsWeb.ConnCase

  import Phoenix.LiveViewTest
  import ChezaCards.ProgressFixtures

  @create_attrs %{level: 42, streak_count: 42, total_stars: 42, last_activity: "2025-03-27T10:46:00Z"}
  @update_attrs %{level: 43, streak_count: 43, total_stars: 43, last_activity: "2025-03-28T10:46:00Z"}
  @invalid_attrs %{level: nil, streak_count: nil, total_stars: nil, last_activity: nil}

  defp create_user_progress(_) do
    user_progress = user_progress_fixture()
    %{user_progress: user_progress}
  end

  describe "Index" do
    setup [:create_user_progress]

    test "lists all user_progress", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/user_progress")

      assert html =~ "Listing User progress"
    end

    test "saves new user_progress", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/user_progress")

      assert index_live |> element("a", "New User progress") |> render_click() =~
               "New User progress"

      assert_patch(index_live, ~p"/user_progress/new")

      assert index_live
             |> form("#user_progress-form", user_progress: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_progress-form", user_progress: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_progress")

      html = render(index_live)
      assert html =~ "User progress created successfully"
    end

    test "updates user_progress in listing", %{conn: conn, user_progress: user_progress} do
      {:ok, index_live, _html} = live(conn, ~p"/user_progress")

      assert index_live |> element("#user_progress-#{user_progress.id} a", "Edit") |> render_click() =~
               "Edit User progress"

      assert_patch(index_live, ~p"/user_progress/#{user_progress}/edit")

      assert index_live
             |> form("#user_progress-form", user_progress: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_progress-form", user_progress: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_progress")

      html = render(index_live)
      assert html =~ "User progress updated successfully"
    end

    test "deletes user_progress in listing", %{conn: conn, user_progress: user_progress} do
      {:ok, index_live, _html} = live(conn, ~p"/user_progress")

      assert index_live |> element("#user_progress-#{user_progress.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#user_progress-#{user_progress.id}")
    end
  end

  describe "Show" do
    setup [:create_user_progress]

    test "displays user_progress", %{conn: conn, user_progress: user_progress} do
      {:ok, _show_live, html} = live(conn, ~p"/user_progress/#{user_progress}")

      assert html =~ "Show User progress"
    end

    test "updates user_progress within modal", %{conn: conn, user_progress: user_progress} do
      {:ok, show_live, _html} = live(conn, ~p"/user_progress/#{user_progress}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User progress"

      assert_patch(show_live, ~p"/user_progress/#{user_progress}/show/edit")

      assert show_live
             |> form("#user_progress-form", user_progress: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#user_progress-form", user_progress: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/user_progress/#{user_progress}")

      html = render(show_live)
      assert html =~ "User progress updated successfully"
    end
  end
end
