defmodule ChezaCards.Cards.PresetContent do
  @moduledoc """
  Manages pre-set CBC-aligned flashcard content.
  """

  alias ChezaCards.Cards

  @doc """
  Creates a collection with pre-set CBC-aligned flashcards.
  """
  def create_preset_collection(user_id, subject) do
    {:ok, collection} =
      Cards.create_collection(%{
        name: get_collection_name(subject),
        description: get_collection_description(subject),
        is_public: true,
        is_premium: false,
        user_id: user_id
      })

    Enum.each(get_preset_flashcards(subject), fn flashcard_attrs ->
      Cards.create_flashcard(Map.put(flashcard_attrs, :collection_id, collection.id))
    end)

    {:ok, collection}
  end

  # Collection names for different subjects
  defp get_collection_name("math_g4"), do: "CBC Math - Grade 4"
  defp get_collection_name("science_g4"), do: "CBC Science - Grade 4"
  defp get_collection_name("swahili_g4"), do: "CBC Kiswahili - Darasa la 4"

  # Collection descriptions for different subjects
  defp get_collection_description("math_g4"), do: "Essential mathematics concepts for Grade 4 students following the CBC curriculum."
  defp get_collection_description("science_g4"), do: "Key science concepts for Grade 4 students following the CBC curriculum."
  defp get_collection_description("swahili_g4"), do: "Maneno na dhana muhimu za Kiswahili kwa wanafunzi wa darasa la 4."

  # Preset flashcards for different subjects
  defp get_preset_flashcards("math_g4") do
    [
      %{
        question: "What is multiplication?",
        answer: "Multiplication is repeated addition. For example, 3 × 4 means adding 3 four times: 3 + 3 + 3 + 3 = 12",
        hint: "Think of groups of equal size",
        tags: ["math", "multiplication", "grade4", "cbc"]
      },
      %{
        question: "What is a fraction?",
        answer: "A fraction represents a part of a whole. It has two parts: numerator (top) and denominator (bottom)",
        hint: "Think of sharing a cake",
        tags: ["math", "fractions", "grade4", "cbc"]
      },
      %{
        question: "What are parallel lines?",
        answer: "Parallel lines are lines that never meet and stay the same distance apart",
        hint: "Think of railway tracks",
        tags: ["math", "geometry", "grade4", "cbc"]
      }
    ]
  end

  defp get_preset_flashcards("science_g4") do
    [
      %{
        question: "What are the three states of matter?",
        answer: "The three states of matter are: solid, liquid, and gas",
        hint: "Think of water in different forms",
        tags: ["science", "matter", "grade4", "cbc"]
      },
      %{
        question: "What is photosynthesis?",
        answer: "Photosynthesis is the process by which plants make their own food using sunlight, water, and carbon dioxide",
        hint: "Think about how plants grow",
        tags: ["science", "plants", "grade4", "cbc"]
      },
      %{
        question: "What causes day and night?",
        answer: "Day and night are caused by the Earth's rotation on its axis",
        hint: "Think about the Earth spinning",
        tags: ["science", "earth", "grade4", "cbc"]
      }
    ]
  end

  defp get_preset_flashcards("swahili_g4") do
    [
      %{
        question: "Taja aina nne za sentensi",
        answer: "1. Sentensi sahili\n2. Sentensi ambatano\n3. Sentensi changamano\n4. Sentensi shiriko",
        hint: "Fikiria jinsi tunavyounda sentensi",
        tags: ["swahili", "grammar", "grade4", "cbc"]
      },
      %{
        question: "Tofauti kati ya kivumishi na kielezi ni nini?",
        answer: "Kivumishi hutoa maelezo zaidi kuhusu nomino, wakati kielezi hutoa maelezo zaidi kuhusu kitenzi",
        hint: "Fikiria neno linalofafanua nini",
        tags: ["swahili", "grammar", "grade4", "cbc"]
      },
      %{
        question: "Nini maana ya methali 'Haraka haraka haina baraka'?",
        answer: "Kufanya mambo kwa haraka sana kunaweza kuleta makosa. Ni bora kufanya mambo taratibu kwa umakini",
        hint: "Fikiria matokeo ya kufanya mambo kwa haraka",
        tags: ["swahili", "proverbs", "grade4", "cbc"]
      }
    ]
  end
end
