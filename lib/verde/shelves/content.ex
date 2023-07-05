defmodule Verde.Shelves.Content do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contents" do
    field :data, :binary

    timestamps()
  end

  @doc false
  def changeset(content, attrs) do
    content
    |> cast(attrs, [:data])
    |> validate_required([:data])
  end
end
