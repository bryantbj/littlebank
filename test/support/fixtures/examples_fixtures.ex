defmodule LittleBank.ExamplesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LittleBank.Examples` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> LittleBank.Examples.create_post()

    post
  end
end
