defmodule Verde.Shelves.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "book" do
    field :authors, {:array, :string}
    field :content_type, :string
    field :description, :string
    field :edition, :string
    field :file_dir, :string
    field :file_extension, :string
    field :file_name, :string
    field :page_number, :integer
    field :published_in, :string
    field :publisher, :string
    field :read_count, :integer
    field :title, :string
    field :volume, :string

    timestamps()
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
      :content_type,
      :description,
      :edition,
      :file_dir,
      :file_extension,
      :file_name,
      :page_number,
      :published_in,
      :publisher,
      :read_count,
      :title,
      :volume
    ])
    |> validate_required([:title, :content_type])
    |> validate_length(:title, min: 1, max: 200)
    |> validate_content_type()
  end

  defp validate_content_type(changeset) do
    content_types = Map.keys(@supported_content_types)

    case Enum.member?(content_types, changeset.changes.content_type) do
      true ->
        file_extension = Map.get(@supported_content_types, changeset.changes.content_type)

        changeset
        |> put_change(:file_extension, file_extension)

      false ->
        changeset
    end
  end
end
