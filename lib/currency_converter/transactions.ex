defmodule CurrencyConverter.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias CurrencyConverter.Repo
  alias CurrencyConverter.Transaction
  alias CurrencyConverter.User
  alias CurrencyConverter.Converter

  @doc """
  Inserts a transaction.

  ## Parameters

    - params: A map containing `user_id` and transaction parameters:
      `from_currency`, `to_currency`, `from_amount` and `conversion_rate`.

  ## Returns

    - {:ok, %Transaction{}} on success.
    - {:error, :user_not_found} if the user is not found.


  """
  def insert_transaction(%{"user_id" => id} = params) do
    with true <- Repo.exists?(from u in User, where: u.id == ^id),
         %Ecto.Changeset{valid?: true} = changeset <- Transaction.changeset(params) do
      Repo.insert(changeset)
    else
      false ->
        Logger.error("User not found.")
        {:error, :user_not_found}

      %Ecto.Changeset{valid?: false} = changeset ->
        Logger.error("Invalid parameters: #{inspect(changeset)}")
        {:error, :invalid_parameters}
    end
  end

  @doc """
  Lists a user's transactions.

  ## Parameters

    - params: A map containing the user's `id`.

  ## Returns

    - {:ok, [%Transaction{}]} on success.
    - {:error, :not_found} if no transactions are found for the user.

  ## Examples

      iex> list_transactions(%{"id" => "some_user_id"})
      {:ok, [%Transaction{}]}

      iex> list_transactions(%{"id" => "non_existent_user_id_or_no_transactions_found"})
      {:error, :not_found}
  """
  def list_transactions(%{"id" => id}) do
    transactions = Repo.all(from t in Transaction, where: t.user_id == ^id)

    case transactions do
      [] -> {:error, :not_found}
      _ -> {:ok, transactions}
    end
  end

  @doc """
  Converts currency and inserts the transaction.

  ## Parameters

    - params: A map containing currency conversion parameters and the user's `id`.

  ## Returns

    - {:ok, %Transaction{}} on success.
    - An error tuple if the conversion or transaction insertion fails.

  ## Examples

      iex> convert_currency(%{"from_currency" => "USD", "to_currency" => "EUR", "from_amount" => 100, "user_id" => "some_user_id"})
      {:ok, %Transaction{}}

      iex> convert_currency(%{"from_currency" => "USD", "to_currency" => "EUR", "from_amount" => 100, "user_id" => "non_existent_user_id"})
      {:error, :user_not_found}
  """
  def convert_currency(params) do
    with request_params <- build_request_params(params),
         {:ok, result} <- Converter.convert(request_params),
         parsed_result <- parse_result(result, params["user_id"]),
         insert_params <- build_insert_params(parsed_result),
         {:ok, _inserted_transaction} <- insert_transaction(insert_params) do
      {:ok, parsed_result}
    else
      error -> error
    end
  end

  defp build_request_params(params) do
    %{
      "to" => params["to_currency"],
      "from" => params["from_currency"],
      "amount" => params["from_amount"]
    }
  end

  defp build_insert_params(params) do
    Map.merge(
      params,
      %{
        "from_amount" => parse_to_integer(params["from_amount"]),
        "conversion_rate" => parse_to_string(params["conversion_rate"]),
        "result" => parse_to_integer(params["result"])
      }
    )
  end

  defp parse_to_integer(amount) when is_float(amount) do
    amount
    |> Float.round(2)
    |> Kernel.*(100)
    |> round()
  end

  defp parse_to_integer(amount), do: amount

  defp parse_result(%{"query" => query, "result" => result, "info" => info}, user_id) do
    %{
      "user_id" => user_id,
      "from_currency" => query["from"],
      "to_currency" => query["to"],
      "from_amount" => query["amount"],
      "conversion_rate" => info["rate"],
      "result" => result,
      "datetime" => DateTime.utc_now()
    }
  end

  defp parse_to_string(rate) when is_integer(rate), do: Integer.to_string(rate)
  defp parse_to_string(rate) when is_float(rate), do: Float.to_string(rate)
end
