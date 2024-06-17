defmodule CurrencyConverter.Converter do
  @moduledoc false
  use Retry

  @doc """
  Converts a specified amount from one currency to another using an external API.

  ## Parameters
    - `%{"to" => to, "from" => from, "amount" => amount}`: A map containing:
      - `to` (string): The target currency code.
      - `from` (string): The source currency code.
      - `amount` (number): The amount of currency to convert.

  ## Returns
    - `{:ok, map}`: A tuple containing the status `:ok` and a map with the conversion result if the request is successful.
    - `{:error, String.t()}`: A tuple containing the status `:error` and an error message if the request fails due to a non-200 status code.
    - `{:error, any}`: A tuple containing the status `:error` and the error reason if the request fails due to an HTTP error.

  ## Examples

    iex> convert(%{"to" => "USD", "from" => "EUR", "amount" => 100})
    {:ok,
      %{"date": "2018-02-22",
      "info": {"rate": 148.972231, "timestamp": 1519328414},
      "query": {"amount": 25, "from": "GBP", "to": "JPY"},
      "result": 3724.305775,
      "success": true
    }}

    iex> convert(%{"to" => "USD", "from" => "EUR", "amount" => 100})
    {:error, "Failed to fetch exchange rates. Status code: 500"}
  """
  def convert(%{"to" => to, "from" => from, "amount" => amount}) do
    url = "#{config()[:base_api_url]}to=#{to}&from=#{from}&amount=#{amount}"

    headers = [{"apikey", config()[:api_key]}]

    result =
      retry with: exponential_backoff() |> randomize |> cap(1_000) |> expiry(10_000) do
        HTTPoison.get(url, headers)
      end

    case result do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed to fetch exchange rates. Status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp config(), do: Application.get_env(:currency_converter, __MODULE__)
end
