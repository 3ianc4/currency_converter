defmodule CurrencyConverter.TransactionsTest do
  use CurrencyConverter.DataCase

  alias CurrencyConverter.Transactions
  alias CurrencyConverter.Transaction
  alias CurrencyConverter.Users

  describe "users" do
    test "insert_transaction/1 with valid data creates a user" do
      {:ok, user} = Users.create_user(%{})

      params = %{
        user_id: user.id,
        from_currency: :USD,
        to_currency: :EUR,
        from_amount: 1000,
        conversion_rate: "10"
      }

      assert {:ok, %Transaction{id: _id}} = Transactions.insert_transaction(params)
    end

    test "insert_transaction/1 fails when user doesn't exists" do
      params = %{
        user_id: Ecto.UUID.generate(),
        from_currency: :USD,
        to_currency: :EUR,
        from_amount: 1000,
        conversion_rate: "10"
      }

      assert {:error, :user_not_found} = Transactions.insert_transaction(params)
    end

    test "insert_transaction/1 fails when params are invalid" do
      {:ok, user} = Users.create_user(%{})

      params = %{user_id: user.id}


      assert {:error, %Ecto.Changeset{valid?: false}} = Transactions.insert_transaction(params)
    end
  end
end
