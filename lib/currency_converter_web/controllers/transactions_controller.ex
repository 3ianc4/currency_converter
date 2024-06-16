defmodule CurrencyConverterWeb.TransactionsController do
  use CurrencyConverterWeb, :controller
  require Logger
  alias CurrencyConverter.Transactions
  alias CurrencyConverter.Inputs.ConvertCurrencyInput

  def list(conn, params) do
    case Transactions.list_transactions(params) do
      {:ok, transactions} ->
      conn
      |> put_status(:ok)
      |> render(:list, transactions: transactions, layout: false)
    
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(:not_found, layout: false)
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

        {:error, :timeout}
        Logger.error("Request timeout")

        conn
        |> put_status(:request_timeout)
        |> render(:timeout, layout: false)
    end
  end
end
