defmodule CurrencyConverter.User do
  @moduledoc """
  Representation of a user.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias CurrencyConverter.Transaction

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "users" do
    field :username, :string

    has_many :transactions, Transaction

    timestamps()
  end

  def changeset(model, params), do: cast(model, params, [:username])
end
