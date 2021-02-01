defmodule Test do
  def do_something(client, text) do
    Tesla.post(client, "http://foo.com", body: Jason.encode!(%{ bar: text }))
    |> IO.inspect
  end

  def client() do
    Tesla.client([
      Tesla.Middleware.JSON
    ])
  end
end
