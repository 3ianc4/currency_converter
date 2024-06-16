defmodule CurrencyConverterWeb.Router do
  use CurrencyConverterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CurrencyConverterWeb.Layouts, :root}
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CurrencyConverterWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", CurrencyConverterWeb do
    pipe_through :browser

    post "/users", UsersController, :create
    get "/transactions", TransactionsController, :list
    post "/convert_currencies", TransactionsController, :convert_currencies
  end

  if Application.compile_env(:currency_converter, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CurrencyConverterWeb.Telemetry
    end
  end
end
