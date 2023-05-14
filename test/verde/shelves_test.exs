defmodule Verde.ShelvesTest do
  use Verde.DataCase

  alias Verde.Shelves

  describe "book" do
    alias Verde.Shelves.Book

    import Verde.ShelvesFixtures

    @invalid_attrs %{
      authors: nil,
      content_type: nil,
      description: nil,
      edition: nil,
      file_dir: nil,
      file_extension: nil,
      file_name: nil,
      page_number: nil,
      published_in: nil,
      publisher: nil,
      read_count: nil,
      title: nil,
      volume: nil
    }

    test "list_book/0 returns all book" do
      book = book_fixture()
      assert Shelves.list_book() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Shelves.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{
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
      }

      assert {:ok, %Book{} = book} = Shelves.create_book(valid_attrs)
      assert book.authors == ["option1", "option2"]
      assert book.content_type == "some content_type"
      assert book.description == "some description"
      assert book.edition == "some edition"
      assert book.file_dir == "some file_dir"
      assert book.file_extension == "some file_extension"
      assert book.file_name == "some file_name"
      assert book.page_number == 42
      assert book.published_in == "some published_in"
      assert book.publisher == "some publisher"
      assert book.read_count == 42
      assert book.title == "some title"
      assert book.volume == "some volume"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shelves.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()

      update_attrs = %{
        authors: ["option1"],
        content_type: "some updated content_type",
        description: "some updated description",
        edition: "some updated edition",
        file_dir: "some updated file_dir",
        file_extension: "some updated file_extension",
        file_name: "some updated file_name",
        page_number: 43,
        published_in: "some updated published_in",
        publisher: "some updated publisher",
        read_count: 43,
        title: "some updated title",
        volume: "some updated volume"
      }

      assert {:ok, %Book{} = book} = Shelves.update_book(book, update_attrs)
      assert book.authors == ["option1"]
      assert book.content_type == "some updated content_type"
      assert book.description == "some updated description"
      assert book.edition == "some updated edition"
      assert book.file_dir == "some updated file_dir"
      assert book.file_extension == "some updated file_extension"
      assert book.file_name == "some updated file_name"
      assert book.page_number == 43
      assert book.published_in == "some updated published_in"
      assert book.publisher == "some updated publisher"
      assert book.read_count == 43
      assert book.title == "some updated title"
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
