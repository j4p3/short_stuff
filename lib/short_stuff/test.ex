defmodule Test do
  def do_something(client, text) do
    Tesla.post(client, "http://foo.com", %{foo: text})
  end

  def client() do
    Tesla.client([Tesla.Middleware.JSON])
  end
end
