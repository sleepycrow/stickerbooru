# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :stickerbooru,
  ecto_repos: [Stickerbooru.Repo],
  generators: [timestamp_type: :utc_datetime]

config :stickerbooru, :instance,
  name: "Stickerbooru"

# Configures the endpoint
config :stickerbooru, StickerbooruWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: StickerbooruWeb.ErrorHTML, json: StickerbooruWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Stickerbooru.PubSub,
  live_view: [signing_salt: "ZNIGkjuG"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :stickerbooru, Stickerbooru.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  stickerbooru: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure sass
config :dart_sass,
  version: "1.81.0",
  stickerbooru: [
    args:
      ~w(css/app.scss ../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__),
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure telegram bot library
config :telegex,
  caller_adapter: {Finch, [receive_timeout: 5 * 1000]}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# Import secret config, if exists
if File.exists?("./config/#{config_env()}.secret.exs") do
  import_config "#{config_env()}.secret.exs"
else
  IO.warn("NO #{config_env()}.secret.exs FILE COULD BE FOUND! You might want to make one - an example one can be found in the config folder.")
end
