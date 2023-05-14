defmodule VerdeWeb.BookLiveTest do
  use VerdeWeb.ConnCase

  import Phoenix.LiveViewTest
  import Verde.ShelvesFixtures

  @create_attrs %{
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
  @update_attrs %{
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
  @invalid_attrs %{
    authors: [],
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

  defp create_book(_) do
    book = book_fixture()
    %{book: book}
  end

  describe "Index" do
    setup [:create_book]

    test "lists all book", %{conn: conn, book: book} do
      {:ok, _index_live, html} = live(conn, ~p"/book")

      assert html =~ "Listing Book"
      assert html =~ book.content_type
    end

    test "saves new book", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/book")

      assert index_live |> element("a", "New Book") |> render_click() =~
               "New Book"

      assert_patch(index_live, ~p"/book/new")

      assert index_live
             |> form("#book-form", book: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#book-form", book: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/book")

      html = render(index_live)
      assert html =~ "Book created successfully"
      assert html =~ "some content_type"
    end

    test "updates book in listing", %{conn: conn, book: book} do
      {:ok, index_live, _html} = live(conn, ~p"/book")

      assert index_live |> element("#book-#{book.id} a", "Edit") |> render_click() =~
               "Edit Book"

      assert_patch(index_live, ~p"/book/#{book}/edit")

      assert index_live
             |> form("#book-form", book: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#book-form", book: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/book")

      html = render(index_live)
      assert html =~ "Book updated successfully"
      assert html =~ "some updated content_type"
    end

    test "deletes book in listing", %{conn: conn, book: book} do
      {:ok, index_live, _html} = live(conn, ~p"/book")

      assert index_live |> element("#book-#{book.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#book-#{book.id}")
    end
  end

  describe "Show" do
    setup [:create_book]

    test "displays book", %{conn: conn, book: book} do
      {:ok, _show_live, html} = live(conn, ~p"/book/#{book}")

      assert html =~ "Show Book"
      assert html =~ book.content_type
    end

    test "updates book within modal", %{conn: conn, book: book} do
      {:ok, show_live, _html} = live(conn, ~p"/book/#{book}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Book"

      assert_patch(show_live, ~p"/book/#{book}/show/edit")

      assert show_live
             |> form("#book-form", book: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#book-form", book: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/book/#{book}")

      html = render(show_live)
      assert html =~ "Book updated successfully"
      assert html =~ "some updated content_type"
    end
  end
end
