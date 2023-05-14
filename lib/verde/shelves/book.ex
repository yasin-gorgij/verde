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

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [
      :authors,
      :content_type,
      :description,
      :edition,
      :file_extension,
      :file_name,
      :file_dir,
      :page_number,
      :published_in,
      :publisher,
      :read_count,
      :title,
      :volume
    ])
    |> validate_required([
      :authors,
      :content_type,
      :description,
      :edition,
      :file_extension,
      :file_name,
      :file_dir,
      :page_number,
      :published_in,
      :publisher,
      :read_count,
      :title,
      :volume
    ])
  end
end
