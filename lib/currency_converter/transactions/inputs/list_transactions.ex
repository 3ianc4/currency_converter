defmodule CurrencyConverter.Inputs.ListTransactionsInput do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :user_id, Ecto.UUID
  end

  @doc false
  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, [:user_id])
    |> validate_required([:user_id])
  end
end
