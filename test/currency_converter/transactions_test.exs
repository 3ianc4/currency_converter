defmodule CurrencyConverter.TransactionsTest do
  use CurrencyConverter.DataCase

  alias CurrencyConverter.Transactions
  alias CurrencyConverter.Transaction
  alias CurrencyConverter.Users

  describe "transactions" do
    test "insert_transaction/1 with valid data inserts a transaction" do
      params = transaction_factory()

      assert {:ok, %Transaction{}} = Transactions.insert_transaction(params)
    end

    test "insert_transaction/1 fails when user doesn't exists" do
      params = transaction_factory(%{user_id: Ecto.UUID.generate()})

      assert {:error, :user_not_found} = Transactions.insert_transaction(params)
    end

    test "insert_transaction/1 fails when params are invalid" do
      user = user_factory()

      params = %{"user_id" => user.id}

      assert {:error, :invalid_parameters} = Transactions.insert_transaction(params)
    end

    test "list_transactions/1 with valid data list all transctions belonging to a user" do
      params = transaction_factory()
      user_id = params["user_id"]

      {:ok, %{id: transaction_id}} = Transactions.insert_transaction(params)

      assert {:ok, [%Transaction{id: ^transaction_id}]} =
               Transactions.list_transactions(%{"user_id" => user_id})
    end

    test "list_transactions/1 with returns error when user doesnt have transactions" do
      user = user_factory()

      assert {:error, :not_found} = Transactions.list_transactions(%{"user_id" => user.id})
    end

    test "list_transactions/1 with returns error when user is not found" do
      assert {:error, :not_found} =
               Transactions.list_transactions(%{"user_id" => Ecto.UUID.generate()})
    end

    test "convert_currency/1 with valid data returns amount converted" do
      params = transaction_factory()
      {:ok, _transaction} = Transactions.convert_currency(params)

      [inserted_transaction] = Repo.all(Transaction)
      assert inserted_transaction.result
    end

    test "convert_currency/1 fails with invalid data" do
      params = %{}

      {:error, "Failed to fetch exchange rates. Status code: 400"} =
        Transactions.convert_currency(params)
    end

    test "convert_currency/1 fails with invalid currency codes" do
      params = transaction_factory(%{from_currency: "INVALID", to_currency: "INVALID"})

      {:error, "Failed to fetch exchange rates. Status code: 400"} =
        Transactions.convert_currency(params)
    end

    test "convert_currency/1 fails with negative amount" do
      params = transaction_factory(%{from_amount: -100})

      {:error, "Failed to fetch exchange rates. Status code: 400"} =
        Transactions.convert_currency(params)
    end
  end

  defp user_factory do
    {:ok, user} = Users.create_user(%{username: "username#{Ecto.UUID.generate()}"})

    user
  end

  defp transaction_factory(attrs \\ %{}) do
    user = user_factory()

    %{
      "user_id" => attrs[:user_id] || user.id,
      "from_currency" => attrs[:from_currency] || "USD",
      "to_currency" => attrs[:to_currency] || "EUR",
      "from_amount" => attrs[:from_amount] || 1000,
      "conversion_rate" => attrs[:conversion_rate] || "10",
      "result" => attrs[:result] || 990
    }
  end
end
