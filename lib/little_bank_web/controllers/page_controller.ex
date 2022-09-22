defmodule LittleBankWeb.PageController do
  use LittleBankWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
