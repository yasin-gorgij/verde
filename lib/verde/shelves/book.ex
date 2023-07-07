defmodule Verde.Shelves.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "book" do
    field :description, :string
    field :title, :string
    field :translator, :string
    field :content_type, :string
    field :authors, {:array, :string}
    field :completion_count, :integer
    field :completion_date, :utc_datetime
    field :content_extension, :string
    field :content_hash, :string
    field :cover_extension, :string
    field :cover_hash, :string
    field :cover_type, :string
    field :edition, :string
    field :latest_page, :string
    field :publisher, :string
    field :publishing_year, :integer
    field :reading_state, :string
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
    "image/vnd.djvu" => "djvu",
    "image/x-djvu" => "djvu",
    "text/markdown" => "md",
    "text/plain" => "txt",
    "text/rtf" => "rtf",
    "text/x-markdown" => "md"
  }

  @supported_cover_types %{
    "image/jpeg" => "jpeg",
    "image/png" => "png",
    "image/svg+xml" => "svg",
    "image/webp" => "webp"
  }

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [
      :authors,
      :completion_count,
      :cover_extension,
      :cover_hash,
      :cover_type,
      :description,
      :edition,
      :publisher,
      :publishing_year,
      :reading_state,
      :title,
      :translator,
      :volume
    ])
    |> validate_required([:title, :cover_hash, :cover_type])
    |> validate_length(:title, min: 1, max: 200)
    |> validate_cover_type()
    |> validate_number(:completion_count, equal_to: 0)
    |> validate_required([:cover_extension])
  end

  defp validate_cover_type(changeset) do
    cover_types = Map.keys(@supported_cover_types)

    case Enum.member?(cover_types, changeset.changes.cover_type) do
      true ->
        cover_extension = Map.get(@supported_cover_types, changeset.changes.cover_type)
        put_change(changeset, :cover_extension, cover_extension)

      false ->
        changeset
    end
  end
end
