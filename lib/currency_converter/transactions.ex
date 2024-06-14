defmodule CurrencyConverter.Transactions do
  @moduledoc """
  The transactions context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias CurrencyConverter.Repo
  alias CurrencyConverter.Transaction
  alias CurrencyConverter.Users

  @doc """
  Inserts a transaction.

  ## Examples

      iex> insert_transaction()
      {:ok, %Transaction{}}

  """
  def insert_transaction(params) do
    case get_user_id(params) do
      {:error, :user_not_found} ->
        Logger.error("User not found.")
        {:error, :user_not_found}

      user_id ->
        %Transaction{}
        |> Transaction.changeset(params)
        |> Repo.insert()
    end
  end

  defp get_user_id(%{user_id: user_id}) do
    case Users.get(user_id) do
      nil -> {:error, :user_not_found}
      user -> user.id
    end
  end
end
