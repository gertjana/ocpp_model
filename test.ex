defmodule MyCommandBehaviour do
  @callback def one_command(list) :: any()
  @callback def another_command_b(list) :: any

  def handle("a", args), do: one_command(args)  # does not recognize command_a
  def handle("b", args), do: another_comand(args) # does not recognize command_b
end

defmodule MyCommandHandler do
  use MyCommandBehaviour

  def command_a(args), do: IO.puts "Command A got called with #{inspect(args)}"
  def command_b(args), do: IO.puts "Command A got called with #{inspect(args)}"

  def main() do
    ...
    handle_command("a", [])
    ...
    handle_command("b", [:foo])
  end
end
