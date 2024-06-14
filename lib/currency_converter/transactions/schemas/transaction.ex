defmodule CurrencyConverter.Transaction do
  @moduledoc """
  Representation of a transaction.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Enum
  alias CurrencyConverter.User

  @required [:from_currency, :to_currency, :from_amount, :conversion_rate, :user_id]

  schema "transactions" do
    field :from_currency, Enum, values: [:BRL, :USD, :EUR, :JPY]
    field :to_currency, Enum, values: [:BRL, :USD, :EUR, :JPY]
    field :from_amount, :integer
    field :conversion_rate, :string

    belongs_to :user, User, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(model, params) do
    model
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
