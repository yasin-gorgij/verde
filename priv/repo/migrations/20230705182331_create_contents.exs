defmodule Verde.Repo.Migrations.CreateContents do
  use Ecto.Migration

  def change do
    create table(:contents) do
      add :data, :binary

      timestamps()
    end
  end
end
