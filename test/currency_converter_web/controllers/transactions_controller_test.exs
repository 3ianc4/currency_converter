defmodule CurrencyConverterWeb.TransactionsControllerTest do
  use CurrencyConverterWeb.ConnCase, async: true

  alias CurrencyConverter.Users
  alias CurrencyConverter.Transactions

  @list_transactions_path "/api/transactions"
  @convert_currencies_path "/api/convert-currencies"

  describe "GET #{@list_transactions_path}" do
    test "returns 200 and successfully lists a user's transactions", %{conn: conn} do
      {:ok, transaction} = create_transaction()
      params = %{"user_id" => transaction.user_id}

      conn = get(conn, @list_transactions_path, params)

      assert html_response(conn, 200) =~ "List of Transactions"
      assert html_response(conn, 200) =~ "#{transaction.user_id}"
      assert html_response(conn, 200) =~ "#{transaction.from_amount}"
      assert html_response(conn, 200) =~ "#{transaction.from_currency}"
      assert html_response(conn, 200) =~ "#{transaction.to_currency}"
    end

    test "returns 404 when no transaction is found", %{conn: conn} do
      conn = get(conn, @list_transactions_path, %{"user_id" => Ecto.UUID.generate()})

      assert html_response(conn, 404) =~ "Your transaction list is empty"
    end

    test "returns 422 when user id is invalid", %{conn: conn} do
      conn = get(conn, @list_transactions_path, %{"user_id" => "invalid format"})

      assert html_response(conn, 422) =~ "Invalid user id!"
    end

    test "returns 422 when params are empty", %{conn: conn} do
      conn = get(conn, @list_transactions_path, %{})

      assert html_response(conn, 422) =~ "Invalid user id!"
    end
  end

  describe "POST #{@convert_currencies_path}" do
    test "returns 200 and successfully convert two currencies", %{conn: conn} do
      user = user_factory()

      params = %{
        "from_currency" => "USD",
        "to_currency" => "EUR",
        "from_amount" => 1000,
        "user_id" => user.id
      }

      conn = post(conn, @convert_currencies_path, params)

      assert html_response(conn, 200) =~ "Currency converted with success"
      assert html_response(conn, 200) =~ "#{user.id}"
      assert html_response(conn, 200) =~ "USD"
      assert html_response(conn, 200) =~ "EUR"
      assert html_response(conn, 200) =~ "Conversion rate:"
    end

    test "returns 200 and successfully convert two currencies when input amount is not integer",
         %{conn: conn} do
      user = user_factory()

      params = %{
        "from_currency" => "USD",
        "to_currency" => "EUR",
        "from_amount" => 1000.5,
        "user_id" => user.id
      }

      conn = post(conn, @convert_currencies_path, params)

      assert html_response(conn, 200) =~ "Currency converted with success"
      assert html_response(conn, 200) =~ "#{user.id}"
      assert html_response(conn, 200) =~ "USD"
      assert html_response(conn, 200) =~ "EUR"
      assert html_response(conn, 200) =~ "Conversion rate:"
    end

    test "returns 422 and fails to convert two currencies when params are invalid", %{conn: conn} do
      user = user_factory()

      params = %{
        "from_currency" => "GLP",
        "to_currency" => "PNL",
        "from_amount" => 0,
        "user_id" => user.id
      }

      conn = post(conn, @convert_currencies_path, params)

      assert html_response(conn, 422) =~ "Parametros inválidos!"
    end

    test "returns 422 and fails to convert currencies with negative amount", %{conn: conn} do
      user = user_factory()

      params = %{
        "from_currency" => "USD",
        "to_currency" => "EUR",
        "from_amount" => -1000,
        "user_id" => user.id
      }

      conn = post(conn, @convert_currencies_path, params)

      assert html_response(conn, 422) =~ "Invalid parameters"
    end

    test "returns 422 and fails to convert currencies with missing parameters", %{conn: conn} do
      conn = post(conn, @convert_currencies_path, %{})

      assert html_response(conn, 422) =~ "Invalid parameters"
    end
  end

  defp user_factory do
    {:ok, user} = Users.create_user(%{username: "username#{Ecto.UUID.generate()}"})

    user
  end

  defp create_transaction() do
    user = user_factory()

    params = %{
      "user_id" => user.id,
      "from_currency" => "USD",
      "to_currency" => "EUR",
      "from_amount" => 1000,
      "conversion_rate" => "10",
      "result" => 990
    }

    Transactions.insert_transaction(params)
  end
end
