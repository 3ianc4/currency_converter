defmodule CurrencyConverter.Services.ConverterTest do
  use CurrencyConverter.DataCase
  alias CurrencyConverter.Converter

  @valid_params %{"to" => "EUR", "from" => "USD", "amount" => 1000}
  @empty_params %{"to" => nil, "from" => nil, "amount" => nil}
  @invalid_params %{"to" => 10, "from" => :EUR, "amount" => -1}

  describe "converter" do
    test "succeeds when parameters are valid" do
      {:ok,
       %{"date" => _, "info" => %{"rate" => _}, "query" => _, "result" => _, "success" => true}} =
        Converter.convert(@valid_params)
    end

    test "fails when parameters are empty" do
      {:error, "Failed to fetch exchange rates. Status code: 400"} =
        Converter.convert(@empty_params)
    end

    test "fails when parameters are invalid" do
      {:error, "Failed to fetch exchange rates. Status code: 400"} =
        Converter.convert(@invalid_params)
    end
  end
end
