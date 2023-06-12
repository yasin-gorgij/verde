defmodule Verde.Shelves do
  @moduledoc """
  The Shelves context.
  """

  import Ecto.Query, warn: false

  alias Verde.Repo
  alias Verde.Shelves.Book

  @conn Verde.Arangox
  @graph_name "shelves"

  @doc """
  Returns the list of book.

  ## Examples

      iex> list_book()
      [%Book{}, ...]

  """
  def list_book do
    Repo.all(Book)
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id)

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, :success}

      iex> create_book(%{field: bad_value})
      {:error, :reason}

  """
  def create_book(attrs \\ %{}) do
    content =
      attrs.temp_file_path
      |> File.read()
      |> elem(1)

    attrs =
      attrs
      |> Map.put(:content_type, extract_content_type(attrs.temp_file_path))
      |> Map.put(:content_hash, hash_then_base64(content, :blake2b))

    changeset = Book.changeset(%Book{}, attrs)
    file_path = "#{changeset.changes.content_hash}.#{changeset.changes.extension}"

    case changeset.valid? do
      true ->
        File.write(file_path, content)
        {:ok, :success}

      false ->
        {:error, :reason}
    end

    # |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  def prepare_arangodb() do
    with {:ok, _} <- Arangox.post(@conn, "/_api/gharial", %{name: @graph_name}),
         {:ok, _} <-
           Arangox.post(@conn, "/_api/gharial/#{@graph_name}/vertex", %{collection: "books"}),
         {:ok, _} <-
           Arangox.post(@conn, "/_api/gharial/#{@graph_name}/vertex", %{collection: "categories"}),
         {:ok, _} <-
           Arangox.post(@conn, "/_api/gharial/#{@graph_name}/vertex", %{collection: "users"}),
         {:ok, _} <-
           Arangox.post(@conn, "/_api/gharial/#{@graph_name}/edge", %{
             collection: "has",
             from: ["users"],
             to: ["books"]
           }),
         {:ok, _} <-
           Arangox.post(@conn, "/_api/gharial/#{@graph_name}/edge", %{
             collection: "attaches_to",
             from: ["categories"],
             to: ["books"]
           }),
         {:ok, _} <-
           Arangox.post(@conn, "/_api/index?collection=books", %{
             type: "persistent",
             unique: true,
             fields: ["content_hash"]
           }),
         {:ok, _} <-
           Arangox.post(@conn, "/_api/index?collection=users", %{
             type: "persistent",
             unique: true,
             fields: ["email"]
           }),
         {:ok, _} <-
           Arangox.post(@conn, "/_api/index?collection=categories", %{
             type: "persistent",
             unique: true,
             fields: ["name"]
           }) do
      {:ok, "Graph, vertex and edge collections and unique indexes are created"}
    end
  end

  defp hash_then_base64(content, hash_algorithm) do
    :crypto.hash(hash_algorithm, content)
    |> Base.url_encode64()
  end

  defp extract_content_type(file_path) do
    %{type: type, subtype: subtype} =
      file_path
      |> FileInfo.get_info()
      |> Map.values()
      |> List.first()

    "#{type}/#{subtype}"
  end
end
