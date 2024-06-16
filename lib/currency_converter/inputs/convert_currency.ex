defmodule CurrencyConverter.Inputs.ConvertCurrencyInput do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @required [:user_id, :from_currency, :to_currency, :from_amount]

  embedded_schema do
    field :user_id, :string
    field :from_currency, :string
    field :to_currency, :string
    field :from_amount, :float
  end

  @doc false
  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_inclusion(:from_currency, ["BRL", "USD", "EUR", "JPY"])
    |> validate_inclusion(:to_currency, ["BRL", "USD", "EUR", "JPY"])
    |> validate_number(:from_amount, greater_than: 0)
  end
end
