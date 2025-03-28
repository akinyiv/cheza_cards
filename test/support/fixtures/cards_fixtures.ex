defmodule ChezaCards.CardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChezaCards.Cards` context.
  """

  @doc """
  Generate a flashcard.
  """
  def flashcard_fixture(attrs \\ %{}) do
    {:ok, flashcard} =
      attrs
      |> Enum.into(%{
        answer: "some answer",
        hint: "some hint",
        question: "some question",
        tags: ["option1", "option2"]
      })
      |> ChezaCards.Cards.create_flashcard()

    flashcard
  end

  @doc """
  Generate a deck.
  """
  def deck_fixture(attrs \\ %{}) do
    {:ok, deck} =
      attrs
      |> Enum.into(%{
        description: "some description",
        is_premium: true,
        is_public: true,
        name: "some name"
      })
      |> ChezaCards.Cards.create_deck()

    deck
  end
end
