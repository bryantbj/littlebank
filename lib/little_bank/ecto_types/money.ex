defmodule LittleBank.EctoTypes.Money do
  use Ecto.Type
  def type, do: :integer

  # Provide custom casting rules.
  # Cast strings into the URI struct to be used at runtime
  def cast(money) when is_binary(money) do
    {
      :ok,
      money
      |> Float.parse()
      |> then(fn {n, _} -> n * 100 end)
      |> trunc()
    }
  end

  def cast(money) when is_float(money) do
    {:ok, money * 100 |> trunc()}
  end

  # Everything else is a failure though
  def cast(_), do: :error

  # When loading data from the database, as long as it's a map,
  # we just put the data back into a URI struct to be stored in
  # the loaded schema struct.
  def load(data) when is_integer(data) do
    {:ok, data / 100}
  end

  # When dumping data to the database, we *expect* a URI struct
  # but any value could be inserted into the schema struct at runtime,
  # so we need to guard against them.
  def dump(data), do: {:ok, data}
end
