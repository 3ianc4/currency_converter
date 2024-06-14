defmodule CurrencyConverter.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :from_currency, :string
      add :to_currency, :string
      add :from_amount, :integer
      add :conversion_rate, :string

      add :user_id, references(:users, type: :uuid)

      timestamps()
    end
  end
end
