defmodule OcppModel.V20.ChargeSystem do
  @moduledoc """
    Behaviour of a ChargeSystem, allowing the module assuming the behaviour to be able to respond to messages send to it

    an example chargesystem might look like this

    ```
    defmodule MyTestChargeSystem do
      @behaviour M.ChargeSystem

      def handle([2, id, action, payload]) do
        case M.ChargeSystem.handle(__MODULE__, action, payload) do
          {:ok, response_payload} -> [3, id, response_payload]
          {:error, error} ->         [4, id, Atom.to_string(error), "", {}]
        end
      end
      def handle([3, id, payload]), do: IO.puts "Received answer for id \#{id}: \#{inspect(payload)}"
      def handle([4, id, err, desc, det]), do: IO.puts "Received error for id \#{id}: \#{err}, \#{desc}, \#{det}"

      @impl M.ChargeSystem
      def authorize(_req),  do: {:ok, %M.AuthorizeResponse{idTokenInfo: %FT.IdTokenInfoType{status: "Accepted"}}}

      @impl M.ChargeSystem
      def boot_notification(_req), do: {:ok, %M.BootNotificationResponse{currentTime: current_time()}}

      @impl M.ChargeSystem
      def heartbeat(_req), do: {:ok, %M.HeartbeatResponse{currentTime: current_time()}}

      @impl M.ChargeSystem
      def transaction_event(_req), do: {:ok, %M.TransactionEventResponse{}}

      defp current_time(), do: DateTime.now!("Etc/UTC") |> DateTime.to_iso8601()
    end
    ```

  """
  alias OcppModel.V20, as: M

  @callback authorize(req :: AuthorizeRequest) :: {:ok, AuthorizeResponse} | {:error, :authorize}
  @callback boot_notification(req :: BootNotificationRequest) :: {:ok, BootNotificationResponse} | {:error, :boot_notification}
  @callback heartbeat(req :: HeartBeatRequest) :: {:ok, HeartbeatResponse} | {:error, :heartbeat}
  @callback transaction_event(req :: TransactionEventRequest) :: {:ok, TransactionEventResponse} | {:error, :transaction_event}

  @spec handle(any(), String.t(), %{}) :: {:ok, %{}} | {:error, :atom}
  def handle(impl, "Authorize", payload), do: impl.authorize(OcppModel.to_struct(M.AuthorizeRequest, payload))
  def handle(impl, "BootNotification", payload), do: impl.authorize(OcppModel.to_struct(M.BootNotificationRequest, payload))
  def handle(impl, "HeartBeat", payload), do: impl.authorize(OcppModel.to_struct(M.HeartBeat, payload))
  def handle(impl, "TransactionEvent", payload), do: impl.authorize(OcppModel.to_struct(M.AuthorizeRequest, payload))
  def handle(_impl, _action, _payload), do: {:error, :unknown_action}

end
