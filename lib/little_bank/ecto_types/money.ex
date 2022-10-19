defmodule LittleBank.EctoTypes.Money do
  use Ecto.Type
  def type, do: :integer

  @doc """
    This is the runtime value, as it appears in structs.
    We want this to be a Float, for easy reasoning.

    ## Examples
      cast("100")
      iex> {:ok, 100.0}

      cast(100)
      iex> {:ok, 100.0}

      cast(100.0)
      iex> {:ok, 100.0}
  """
  #
  #
  def cast(money) when is_binary(money), do: {:ok, binary_to_float(money)}
  def cast(money) when is_integer(money), do: {:ok, integer_to_float(money)}
  def cast(money) when is_float(money), do: {:ok, money}
  def cast(_), do: :error

  # When loading the data from the database, we're
  # converting from Integer to Float.
  def load(data) when is_integer(data) do
    {:ok, data / 100}
  end

  # When dumping data to the database, we *expect* to
  # always have a runtime value, which is a Float.
  #
  # However, since the value can be changed to anything
  # at runtime, we need to account for different scenarios.
  #
  # The output should be an integer here, which is the
  # database value.
  def dump(data) when is_binary(data), do: {:ok, binary_to_integer(data)}
  def dump(data) when is_float(data), do: {:ok, float_to_integer(data)}
  def dump(data), do: {:ok, data}

  defp binary_to_integer(data) do
    data
    |> binary_to_float()
    |> trunc()
  end

  defp binary_to_float(data) do
    data
    |> Float.parse()
    |> then(fn {n, _} -> n * 100 end)
  end

  defp float_to_integer(data) do
    data * 100 |> trunc()
  end

  defp integer_to_float(data) do
    data * 1.0
  end
end
