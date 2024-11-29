defmodule Stickerbooru.Config do
  def get([_ | _] = path, default \\ nil) do
    case fetch(path) do
      {:ok, value} -> value
      :error -> default
    end
  end

  def fetch([root_key | keys]) do
    root = Application.fetch_env(:stickerbooru, root_key)
    Enum.reduce_while(keys, root, fn
      key, {:ok, config} when is_map(config) or is_list(config) ->
        case Access.fetch(config, key) do
          :error -> {:halt, :error}
          result -> {:cont, result}
        end

      _, _ -> {:halt, :error}
    end)
  end
end
