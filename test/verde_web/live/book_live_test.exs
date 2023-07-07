defmodule VerdeWeb.BookLiveTest do
  use VerdeWeb.ConnCase

  import Phoenix.LiveViewTest
  import Verde.ShelvesFixtures

  @create_attrs %{description: "some description", title: "some title", translator: "some translator", content_type: "some content_type", authors: ["option1", "option2"], completion_count: 42, completion_date: "2023-07-06T14:15:00Z", content_extension: "some content_extension", content_hash: "some content_hash", cover_extension: "some cover_extension", cover_hash: "some cover_hash", cover_type: "some cover_type", edition: "some edition", latest_page: "some latest_page", publisher: "some publisher", publishing_year: 42, reading_state: "some reading_state", volume: "some volume"}
  @update_attrs %{description: "some updated description", title: "some updated title", translator: "some updated translator", content_type: "some updated content_type", authors: ["option1"], completion_count: 43, completion_date: "2023-07-07T14:15:00Z", content_extension: "some updated content_extension", content_hash: "some updated content_hash", cover_extension: "some updated cover_extension", cover_hash: "some updated cover_hash", cover_type: "some updated cover_type", edition: "some updated edition", latest_page: "some updated latest_page", publisher: "some updated publisher", publishing_year: 43, reading_state: "some updated reading_state", volume: "some updated volume"}
  @invalid_attrs %{description: nil, title: nil, translator: nil, content_type: nil, authors: [], completion_count: nil, completion_date: nil, content_extension: nil, content_hash: nil, cover_extension: nil, cover_hash: nil, cover_type: nil, edition: nil, latest_page: nil, publisher: nil, publishing_year: nil, reading_state: nil, volume: nil}

  defp create_book(_) do
    book = book_fixture()
    %{book: book}
  end

  describe "Index" do
    setup [:create_book]

    test "lists all book", %{conn: conn, book: book} do
      {:ok, _index_live, html} = live(conn, ~p"/book")

      assert html =~ "Listing Book"
      assert html =~ book.description
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
      assert html =~ "some description"
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
      assert html =~ "some updated description"
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
      assert html =~ book.description
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
      assert html =~ "some updated description"
    end
  end
end
