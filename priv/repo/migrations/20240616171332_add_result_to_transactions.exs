defmodule CurrencyConverter.Repo.Migrations.AddResultToTransactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :result, :integer, null: false
    end
  end
end
