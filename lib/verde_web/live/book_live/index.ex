defmodule VerdeWeb.BookLive.Index do
  use VerdeWeb, :live_view

  alias Verde.Shelves
  alias Verde.Shelves.Book

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :book_collection, Shelves.list_book())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Book")
    |> assign(:book, Shelves.get_book!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Book")
    |> assign(:book, %Book{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Book")
    |> assign(:book, nil)
  end

  @impl true
  def handle_info({VerdeWeb.BookLive.FormComponent, {:saved, book}}, socket) do
    {:noreply, stream_insert(socket, :book_collection, book)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    book = Shelves.get_book!(id)
    {:ok, _} = Shelves.delete_book(book)

    {:noreply, stream_delete(socket, :book_collection, book)}
  end
end
