defmodule Verde.Shelves.Content do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contents" do
    field :data, :binary
    field :data_id, :string

    timestamps()
  end

  @doc false
  def changeset(content, attrs) do
    content
    |> cast(attrs, [:data_id, :data])
    |> validate_required([:data_id, :data])
  end
end
