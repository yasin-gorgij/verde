defmodule Verde.ShelvesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Verde.Shelves` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title",
        translator: "some translator",
        content_type: "some content_type",
        authors: ["option1", "option2"],
        completion_count: 42,
        completion_date: ~U[2023-07-06 14:15:00Z],
        content_extension: "some content_extension",
        content_hash: "some content_hash",
        cover_extension: "some cover_extension",
        cover_hash: "some cover_hash",
        cover_type: "some cover_type",
        edition: "some edition",
        latest_page: "some latest_page",
        publisher: "some publisher",
        publishing_year: 42,
        reading_state: "some reading_state",
        volume: "some volume"
      })
      |> Verde.Shelves.create_book()

    book
  end
end
