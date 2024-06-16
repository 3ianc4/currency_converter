defmodule CurrencyConverter.Converter do
  @moduledoc false

  def convert(%{"to" => to, "from" => from, "amount" => amount}) do
    url = "#{config()[:base_api_url]}to=#{to}&from=#{from}&amount=#{amount}"

    headers = [{"apikey", config()[:api_key]}]

    case HTTPoison.get(url, headers) do
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
