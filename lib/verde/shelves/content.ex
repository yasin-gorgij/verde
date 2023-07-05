defmodule Verde.Shelves.Content do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contents" do
    field :data, :binary
    field :hash, :string
    field :user_id, :string

    timestamps()
  end

  @doc false
  def changeset(content, attrs) do
    content
    |> cast(attrs, [:user_id, :hash, :data])
    |> validate_required([:user_id, :hash, :data])
  end
end
