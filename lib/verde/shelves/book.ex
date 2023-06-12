defmodule Verde.Shelves.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "book" do
    field :authors, {:array, :string}
    field :content_hash, :string
    field :content_type, :string
    field :creation_date, :utc_datetime
    field :description, :string
    field :edition, :string
    field :extension, :string
    field :latest_page, :string
    field :publisher, :string
    field :publishing_year, :integer
    field :read_count, :integer
    field :reading_status, :string
    field :title, :string
    field :volume, :string
  end

  @supported_content_types %{
    "application/epub+zip" => "epub",
    "application/msword" => "doc",
    "application/pdf" => "pdf",
    "application/postscript" => "ps",
    "application/rtf" => "rtf",
    "application/vnd.amazon.mobi8-ebook" => "azw",
    "application/vnd.comicbook-rar" => "cbr",
    "application/vnd.comicbook+zip" => "cbz",
    "application/vnd.ms-htmlhelp" => "chm",
    "application/vnd.ms-powerpoint" => "ppt",
    "application/vnd.oasis.opendocument.presentation" => "odp",
    "application/vnd.oasis.opendocument.text" => "odf",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" => "pptx",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" => "docx",
    "application/x-bzpdf" => "pdf",
    "application/x-gzpdf" => "pdf",
    "application/x-mobipocket-ebook" => "mobi",
    "application/x-pdf" => "pdf",
    "image/jpeg" => "jpeg",
    "image/png" => "png",
    "image/svg+xml" => "svg",
    "image/vnd.djvu" => "djvu",
    "image/webp" => "webp",
    "image/x-djvu" => "djvu",
    "text/markdown" => "md",
    "text/plain" => "txt",
    "text/rtf" => "rtf",
    "text/x-markdown" => "md"
  }

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [
      :authors,
      :content_hash,
      :content_type,
      :creation_date,
      :description,
      :edition,
      :extension,
      :latest_page,
      :publisher,
      :publishing_year,
      :read_count,
      :reading_status,
      :title,
      :volume
    ])
    |> validate_required([:title, :content_hash, :content_type])
    |> validate_length(:title, min: 1, max: 200)
    |> validate_content_type()
    |> validate_required([:extension])
    |> put_change(:creation_date, DateTime.utc_now())
  end

  defp validate_content_type(changeset) do
    content_types = Map.keys(@supported_content_types)

    case Enum.member?(content_types, changeset.changes.content_type) do
      true ->
        extension = Map.get(@supported_content_types, changeset.changes.content_type)

        changeset
        |> put_change(:extension, extension)

      false ->
        changeset
    end
  end
end
