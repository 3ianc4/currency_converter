defmodule CurrencyConverterWeb.TransactionsController do
  use CurrencyConverterWeb, :controller
  require Logger
  alias CurrencyConverter.Transactions
  alias CurrencyConverter.Inputs.ConvertCurrencyInput
  alias CurrencyConverter.Inputs.ListTransactionsInput

  def list(conn, params) do
    with %Ecto.Changeset{valid?: true} <- ListTransactionsInput.changeset(params),
         {:ok, transactions} <- Transactions.list_transactions(params) do
      conn
      |> put_status(:ok)
      |> render(:list, transactions: transactions, layout: false)
    else
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(:not_found, layout: false)

      %Ecto.Changeset{valid?: false} = changeset ->
        Logger.error("Invalid parameters: #{inspect(changeset)}")

        conn
        |> put_status(:unprocessable_entity)
        |> render(:invalid_user_id, layout: false)
    end
  end

  def convert_currencies(conn, params) do
    with %Ecto.Changeset{valid?: true} <- ConvertCurrencyInput.changeset(params),
         {:ok, converted_currency} <- Transactions.convert_currency(params) do
      conn
      |> put_status(:ok)
      |> render(:currency, currency: converted_currency, layout: false)
    else
      %Ecto.Changeset{valid?: false} = changeset ->
        Logger.error("Invalid parameters: #{inspect(changeset)}")

        conn
        |> put_status(:unprocessable_entity)
        |> render(:invalid_parameters, layout: false)

      {:error, :timeout} ->
        Logger.error("Request timeout")

        conn
        |> put_status(:request_timeout)
        |> render(:timeout, layout: false)
    end
  end
end
