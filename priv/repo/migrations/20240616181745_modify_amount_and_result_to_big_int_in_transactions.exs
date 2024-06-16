defmodule CurrencyConverter.Repo.Migrations.ModifyAmountAndResultToBigIntInTransactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      modify :from_amount, :bigint
      modify :result, :bigint
    end
  end
end
