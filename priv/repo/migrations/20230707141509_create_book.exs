defmodule Verde.Repo.Migrations.CreateBook do
  use Ecto.Migration

  def change do
    create table(:book) do
      add :authors, {:array, :string}
      add :completion_count, :integer
      add :completion_date, :utc_datetime
      add :content_extension, :string
      add :content_hash, :string
      add :content_type, :string
      add :cover_extension, :string
      add :cover_hash, :string
      add :cover_type, :string
      add :description, :string
      add :edition, :string
      add :latest_page, :string
      add :publisher, :string
      add :publishing_year, :integer
      add :reading_state, :string
      add :title, :string
      add :translator, :string
      add :volume, :string

      timestamps()
    end
  end
end
