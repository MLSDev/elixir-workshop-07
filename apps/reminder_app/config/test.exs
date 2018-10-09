use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

config :reminder_app, slack_client: ReminderApp.Slack.Sandbox