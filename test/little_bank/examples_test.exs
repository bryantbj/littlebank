defmodule LittleBank.ExamplesTest do
  use LittleBank.DataCase

  alias LittleBank.Examples

  describe "posts" do
    alias LittleBank.Examples.Post

    import LittleBank.ExamplesFixtures

    @invalid_attrs %{title: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Examples.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Examples.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Post{} = post} = Examples.create_post(valid_attrs)
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Examples.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Post{} = post} = Examples.update_post(post, update_attrs)
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Examples.update_post(post, @invalid_attrs)
      assert post == Examples.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Examples.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Examples.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Examples.change_post(post)
    end
  end
end
