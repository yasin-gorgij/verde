defmodule Verde.ShelvesTest do
  use Verde.DataCase

  alias Verde.Shelves

  describe "book" do
    alias Verde.Shelves.Book

    import Verde.ShelvesFixtures

    @invalid_attrs %{description: nil, title: nil, translator: nil, content_type: nil, authors: nil, completion_count: nil, completion_date: nil, content_extension: nil, content_hash: nil, cover_extension: nil, cover_hash: nil, cover_type: nil, edition: nil, latest_page: nil, publisher: nil, publishing_year: nil, reading_state: nil, volume: nil}

    test "list_book/0 returns all book" do
      book = book_fixture()
      assert Shelves.list_book() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Shelves.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{description: "some description", title: "some title", translator: "some translator", content_type: "some content_type", authors: ["option1", "option2"], completion_count: 42, completion_date: ~U[2023-07-06 14:15:00Z], content_extension: "some content_extension", content_hash: "some content_hash", cover_extension: "some cover_extension", cover_hash: "some cover_hash", cover_type: "some cover_type", edition: "some edition", latest_page: "some latest_page", publisher: "some publisher", publishing_year: 42, reading_state: "some reading_state", volume: "some volume"}

      assert {:ok, %Book{} = book} = Shelves.create_book(valid_attrs)
      assert book.description == "some description"
      assert book.title == "some title"
      assert book.translator == "some translator"
      assert book.content_type == "some content_type"
      assert book.authors == ["option1", "option2"]
      assert book.completion_count == 42
      assert book.completion_date == ~U[2023-07-06 14:15:00Z]
      assert book.content_extension == "some content_extension"
      assert book.content_hash == "some content_hash"
      assert book.cover_extension == "some cover_extension"
      assert book.cover_hash == "some cover_hash"
      assert book.cover_type == "some cover_type"
      assert book.edition == "some edition"
      assert book.latest_page == "some latest_page"
      assert book.publisher == "some publisher"
      assert book.publishing_year == 42
      assert book.reading_state == "some reading_state"
      assert book.volume == "some volume"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shelves.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", translator: "some updated translator", content_type: "some updated content_type", authors: ["option1"], completion_count: 43, completion_date: ~U[2023-07-07 14:15:00Z], content_extension: "some updated content_extension", content_hash: "some updated content_hash", cover_extension: "some updated cover_extension", cover_hash: "some updated cover_hash", cover_type: "some updated cover_type", edition: "some updated edition", latest_page: "some updated latest_page", publisher: "some updated publisher", publishing_year: 43, reading_state: "some updated reading_state", volume: "some updated volume"}

      assert {:ok, %Book{} = book} = Shelves.update_book(book, update_attrs)
      assert book.description == "some updated description"
      assert book.title == "some updated title"
      assert book.translator == "some updated translator"
      assert book.content_type == "some updated content_type"
      assert book.authors == ["option1"]
      assert book.completion_count == 43
      assert book.completion_date == ~U[2023-07-07 14:15:00Z]
      assert book.content_extension == "some updated content_extension"
      assert book.content_hash == "some updated content_hash"
      assert book.cover_extension == "some updated cover_extension"
      assert book.cover_hash == "some updated cover_hash"
      assert book.cover_type == "some updated cover_type"
      assert book.edition == "some updated edition"
      assert book.latest_page == "some updated latest_page"
      assert book.publisher == "some updated publisher"
      assert book.publishing_year == 43
      assert book.reading_state == "some updated reading_state"
      assert book.volume == "some updated volume"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Shelves.update_book(book, @invalid_attrs)
      assert book == Shelves.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Shelves.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Shelves.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Shelves.change_book(book)
    end
  end
end
