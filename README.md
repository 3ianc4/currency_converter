# Currency Converter

## Introduction
This API is a currency converter that facilitates conversions between BRL, USD, EUR, and JPY, providing real-time exchange rates for accurate financial calculations.

## Install
### Prerequisites
- Ensure you have ASDF installed. You can follow the instructions on the [ASDF documentation](https://asdf-vm.com/guide/getting-started.html#_2-install-asdf).

```
# Clone the repository:
git clone https://github.com/guzenski/currency_converter
cd currency_converter

# Install Elixir and Erlang versions specified in .tool-versions:
asdf install

# Install dependencies
mix deps.get

# Compile project
mix deps.compile
mix compile

# Run test
mix test

# Run
iex -S mix
```

The API will be running at http://localhost:4000.
All endpoints can be accessed in the main page.

## Features

- Create a user
- Convert between BRL, USD, EUR, and JPY
- List user's conversions

## Architecture

- **Controller Layer**: Handles incoming requests and routes them to the appropriate service.
- **Context Layer**: Contains the business logic for fetching and converting currency rates.
- **Service Layer**: Manages data retrieval from external exchange rate APIs.

## Technologies

- **Elixir**
- **Phoenix**
- **ASDF**: Utilized for managing the project's runtime versions and ensuring consistency across development environments.
- **HTTPoison**: Employed for making HTTP requests.