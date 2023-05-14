defmodule Verde.Shelves do
  @moduledoc """
  The Shelves context.
  """

  import Ecto.Query, warn: false
  alias Verde.Repo

  alias Verde.Shelves.Book

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
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    content =
      attrs.temp_file_path
      |> File.read()
      |> elem(1)

    content_type = extract_content_type(attrs.temp_file_path)

    attrs =
      attrs
      |> Map.put(:content_type, content_type)
      |> Map.put(:file_name, hash_and_encode_content(content))

    changeset = Book.changeset(%Book{}, attrs)

    file_path =
      "#{changeset.changes.file_dir}/#{changeset.changes.file_name}.#{changeset.changes.file_extension}"

    case changeset.valid? do
      true ->
        File.mkdir_p(changeset.changes.file_dir)
        File.write(file_path, content)

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
  
  defp hash_and_encode_content(content) do
    :crypto.hash(:blake2b, content)
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
