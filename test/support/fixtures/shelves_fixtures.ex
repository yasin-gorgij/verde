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
        authors: ["option1", "option2"],
        content_type: "some content_type",
        description: "some description",
        edition: "some edition",
        file_dir: "some file_dir",
        file_extension: "some file_extension",
        file_name: "some file_name",
        page_number: 42,
        published_in: "some published_in",
        publisher: "some publisher",
        read_count: 42,
        title: "some title",
        volume: "some volume"
      })
      |> Verde.Shelves.create_book()

    book
  end
end
