defmodule ChezaCards.CardsTest do
  use ChezaCards.DataCase

  alias ChezaCards.Cards

  describe "flashcards" do
    alias ChezaCards.Cards.Flashcard

    import ChezaCards.CardsFixtures

    @invalid_attrs %{hint: nil, question: nil, answer: nil, tags: nil}

    test "list_flashcards/0 returns all flashcards" do
      flashcard = flashcard_fixture()
      assert Cards.list_flashcards() == [flashcard]
    end

    test "get_flashcard!/1 returns the flashcard with given id" do
      flashcard = flashcard_fixture()
      assert Cards.get_flashcard!(flashcard.id) == flashcard
    end

    test "create_flashcard/1 with valid data creates a flashcard" do
      valid_attrs = %{hint: "some hint", question: "some question", answer: "some answer", tags: ["option1", "option2"]}

      assert {:ok, %Flashcard{} = flashcard} = Cards.create_flashcard(valid_attrs)
      assert flashcard.hint == "some hint"
      assert flashcard.question == "some question"
      assert flashcard.answer == "some answer"
      assert flashcard.tags == ["option1", "option2"]
    end

    test "create_flashcard/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cards.create_flashcard(@invalid_attrs)
    end

    test "update_flashcard/2 with valid data updates the flashcard" do
      flashcard = flashcard_fixture()
      update_attrs = %{hint: "some updated hint", question: "some updated question", answer: "some updated answer", tags: ["option1"]}

      assert {:ok, %Flashcard{} = flashcard} = Cards.update_flashcard(flashcard, update_attrs)
      assert flashcard.hint == "some updated hint"
      assert flashcard.question == "some updated question"
      assert flashcard.answer == "some updated answer"
      assert flashcard.tags == ["option1"]
    end

    test "update_flashcard/2 with invalid data returns error changeset" do
      flashcard = flashcard_fixture()
      assert {:error, %Ecto.Changeset{}} = Cards.update_flashcard(flashcard, @invalid_attrs)
      assert flashcard == Cards.get_flashcard!(flashcard.id)
    end

    test "delete_flashcard/1 deletes the flashcard" do
      flashcard = flashcard_fixture()
      assert {:ok, %Flashcard{}} = Cards.delete_flashcard(flashcard)
      assert_raise Ecto.NoResultsError, fn -> Cards.get_flashcard!(flashcard.id) end
    end

    test "change_flashcard/1 returns a flashcard changeset" do
      flashcard = flashcard_fixture()
      assert %Ecto.Changeset{} = Cards.change_flashcard(flashcard)
    end
  end

  describe "decks" do
    alias ChezaCards.Cards.Deck

    import ChezaCards.CardsFixtures

    @invalid_attrs %{name: nil, description: nil, is_public: nil, is_premium: nil}

    test "list_decks/0 returns all decks" do
      deck = deck_fixture()
      assert Cards.list_decks() == [deck]
    end

    test "get_deck!/1 returns the deck with given id" do
      deck = deck_fixture()
      assert Cards.get_deck!(deck.id) == deck
    end

    test "create_deck/1 with valid data creates a deck" do
      valid_attrs = %{name: "some name", description: "some description", is_public: true, is_premium: true}

      assert {:ok, %Deck{} = deck} = Cards.create_deck(valid_attrs)
      assert deck.name == "some name"
      assert deck.description == "some description"
      assert deck.is_public == true
      assert deck.is_premium == true
    end

    test "create_deck/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cards.create_deck(@invalid_attrs)
    end

    test "update_deck/2 with valid data updates the deck" do
      deck = deck_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", is_public: false, is_premium: false}

      assert {:ok, %Deck{} = deck} = Cards.update_deck(deck, update_attrs)
      assert deck.name == "some updated name"
      assert deck.description == "some updated description"
      assert deck.is_public == false
      assert deck.is_premium == false
    end

    test "update_deck/2 with invalid data returns error changeset" do
      deck = deck_fixture()
      assert {:error, %Ecto.Changeset{}} = Cards.update_deck(deck, @invalid_attrs)
      assert deck == Cards.get_deck!(deck.id)
    end

    test "delete_deck/1 deletes the deck" do
      deck = deck_fixture()
      assert {:ok, %Deck{}} = Cards.delete_deck(deck)
      assert_raise Ecto.NoResultsError, fn -> Cards.get_deck!(deck.id) end
    end

    test "change_deck/1 returns a deck changeset" do
      deck = deck_fixture()
      assert %Ecto.Changeset{} = Cards.change_deck(deck)
    end
  end
end
