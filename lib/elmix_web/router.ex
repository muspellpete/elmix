defmodule ElmixWeb.Router do
  use ElmixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElmixWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api" do
    pipe_through :api
    forward("/graphql", Absinthe.Plug, schema: ElmixWeb.Schema)

    if Mix.env() == :dev do
      forward("graphiql", Absinthe.Plug.GraphiQL, schema: ElmixWeb.Schema)
    end
  end
end
