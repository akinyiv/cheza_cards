defmodule ChezaCardsWeb.FlashcardLiveTest do
  use ChezaCardsWeb.ConnCase

  import Phoenix.LiveViewTest
  import ChezaCards.CardsFixtures

  @create_attrs %{hint: "some hint", question: "some question", answer: "some answer", tags: ["option1", "option2"]}
  @update_attrs %{hint: "some updated hint", question: "some updated question", answer: "some updated answer", tags: ["option1"]}
  @invalid_attrs %{hint: nil, question: nil, answer: nil, tags: []}

  defp create_flashcard(_) do
    flashcard = flashcard_fixture()
    %{flashcard: flashcard}
  end

  describe "Index" do
    setup [:create_flashcard]

    test "lists all flashcards", %{conn: conn, flashcard: flashcard} do
      {:ok, _index_live, html} = live(conn, ~p"/flashcards")

      assert html =~ "Listing Flashcards"
      assert html =~ flashcard.hint
    end

    test "saves new flashcard", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/flashcards")

      assert index_live |> element("a", "New Flashcard") |> render_click() =~
               "New Flashcard"

      assert_patch(index_live, ~p"/flashcards/new")

      assert index_live
             |> form("#flashcard-form", flashcard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#flashcard-form", flashcard: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/flashcards")

      html = render(index_live)
      assert html =~ "Flashcard created successfully"
      assert html =~ "some hint"
    end

    test "updates flashcard in listing", %{conn: conn, flashcard: flashcard} do
      {:ok, index_live, _html} = live(conn, ~p"/flashcards")

      assert index_live |> element("#flashcards-#{flashcard.id} a", "Edit") |> render_click() =~
               "Edit Flashcard"

      assert_patch(index_live, ~p"/flashcards/#{flashcard}/edit")

      assert index_live
             |> form("#flashcard-form", flashcard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#flashcard-form", flashcard: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/flashcards")

      html = render(index_live)
      assert html =~ "Flashcard updated successfully"
      assert html =~ "some updated hint"
    end

    test "deletes flashcard in listing", %{conn: conn, flashcard: flashcard} do
      {:ok, index_live, _html} = live(conn, ~p"/flashcards")

      assert index_live |> element("#flashcards-#{flashcard.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#flashcards-#{flashcard.id}")
    end
  end

  describe "Show" do
    setup [:create_flashcard]

    test "displays flashcard", %{conn: conn, flashcard: flashcard} do
      {:ok, _show_live, html} = live(conn, ~p"/flashcards/#{flashcard}")

      assert html =~ "Show Flashcard"
      assert html =~ flashcard.hint
    end

    test "updates flashcard within modal", %{conn: conn, flashcard: flashcard} do
      {:ok, show_live, _html} = live(conn, ~p"/flashcards/#{flashcard}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Flashcard"

      assert_patch(show_live, ~p"/flashcards/#{flashcard}/show/edit")

      assert show_live
             |> form("#flashcard-form", flashcard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#flashcard-form", flashcard: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/flashcards/#{flashcard}")

      html = render(show_live)
      assert html =~ "Flashcard updated successfully"
      assert html =~ "some updated hint"
    end
  end
end
