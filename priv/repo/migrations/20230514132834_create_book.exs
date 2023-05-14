defmodule Verde.Repo.Migrations.CreateBook do
  use Ecto.Migration

  def change do
    create table(:book) do
      add :authors, {:array, :string}
      add :content_type, :string
      add :description, :string
      add :edition, :string
      add :file_extension, :string
      add :file_name, :string
      add :file_dir, :string
      add :page_number, :integer
      add :published_in, :string
      add :publisher, :string
      add :read_count, :integer
      add :title, :string
      add :volume, :string

      timestamps()
    end
  end
end
