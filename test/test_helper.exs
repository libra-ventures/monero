Code.require_file("default_helper.exs", __DIR__)

Application.ensure_all_started(:hackney)
Application.ensure_all_started(:bypass)

ExUnit.start()
