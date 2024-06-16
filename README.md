# Currency Converter

## Introduction
This API is a currency converter that facilitates conversions between BRL, USD, EUR, and JPY, providing real-time exchange rates for accurate financial calculations.

## Install

### Prerequisites
Ensure you have ASDF installed. You can follow the instructions on the [ASDF documentation](https://asdf-vm.com/guide/getting-started.html#_2-install-asdf).

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


## Endpoints
All endpoints can be accessed in the main page.
You can also test each endpoint with `curl` or `postman`, you will receive a HTML page.

## Creating a user

**POST /api/users**\
To create a user\
*Required parameters*:\
`username`: string

```
curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"username": "add_your_username_here"}' \
     http://localhost:4000/api/users
```

As result you can get user_id with the returned data for the next steps.

**GET /api/transactions**\
To list users transactions\
*Required parameters*:\
`user_id`: uuid
```
curl -X GET \
     -H "Content-Type: application/json" \
     -d '{"id": "some_user_id"}' \
     http://localhost:4000/api/transactions
```

**POST /api/convert-currencies**\
To convert a currency\
**Required parameters**:\
`user_id`: uuid\
`from_currency`: string (must be EUR, USD, JPY or BRL)\
`to_currency`: string (must be EUR, USD, JPY or BRL)\
`from_amount`: float or integer

```
curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"user_id": "some-user-id", "from_currency": "BRL", "to_currency": "USD", "from_amount": 1000}' \
     http://localhost:4000/api/convert-currencies
```

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