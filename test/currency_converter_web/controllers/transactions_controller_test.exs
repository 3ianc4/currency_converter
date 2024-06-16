defmodule CurrencyConverterWeb.TransactionsControllerTest do
  use CurrencyConverterWeb.ConnCase, async: true

  alias CurrencyConverter.Users
  alias CurrencyConverter.Transactions

  describe "GET /transactions" do
    test "successfully lists a user's transactions", %{conn: conn} do
      {:ok, transaction} = create_transaction()
      params = %{"id" => transaction.user_id}

      conn = get(conn, "/api/transactions", params)

      assert html_response(conn, 200) =~ "List of Transactions"
      assert html_response(conn, 200) =~ "#{transaction.user_id}"
      assert html_response(conn, 200) =~ "#{transaction.from_amount}"
      assert html_response(conn, 200) =~ "#{transaction.from_currency}"
      assert html_response(conn, 200) =~ "#{transaction.to_currency}"
    end

    test "returns not found when no transaction is found", %{conn: conn} do
      conn = get(conn, "/api/transactions", %{"id" => Ecto.UUID.generate()})

      assert html_response(conn, 404) =~ "Your transaction list is empty"
    end
  end

  describe "POST /transactions" do
    test "successfully convert two currencies", %{conn: conn} do
      user = user_factory()

      params = %{
        "from_currency" => "USD",
        "to_currency" => "EUR",
        "from_amount" => 1000,
        "user_id" => user.id
      }

      conn = post(conn, "/api/convert_currencies", params)

      assert html_response(conn, 200) =~ "Currency Converted with Success!"
      assert html_response(conn, 200) =~ "#{user.id}"
      assert html_response(conn, 200) =~ "USD"
      assert html_response(conn, 200) =~ "EUR"
      assert html_response(conn, 200) =~ "Conversion rate:"
    end

    test "successfully convert two currencies when input amount is not integer", %{conn: conn} do
      user = user_factory()

      params = %{
        "from_currency" => "USD",
        "to_currency" => "EUR",
        "from_amount" => 1000.5,
        "user_id" => user.id
      }

      conn = post(conn, "/api/convert_currencies", params)

      assert html_response(conn, 200) =~ "Currency Converted with Success!"
      assert html_response(conn, 200) =~ "#{user.id}"
      assert html_response(conn, 200) =~ "USD"
      assert html_response(conn, 200) =~ "EUR"
      assert html_response(conn, 200) =~ "Conversion rate:"
    end

    test "fails to convert two currencies when params are invalid", %{conn: conn} do
      user = user_factory()

      params = %{
        "from_currency" => "GLP",
        "to_currency" => "PNL",
        "from_amount" => 0,
        "user_id" => user.id
      }

      conn = post(conn, "/api/convert_currencies", params)

      assert html_response(conn, 422) =~ "Parametros inválidos!"
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
