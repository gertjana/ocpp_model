defmodule OcppModel.V20.Charger do
  @moduledoc """
    Behaviour of a Charger, allowing the module assuming the behaviour to be able to respond to messages send to it

    an example chargesystem might look like this

    ```
    defmodule MyTestCharger do
      @behaviour M.Charger

      def handle([2, id, action, payload]) do
        case M.Charger.handle(MyTestCharger, action, payload) do
          {:ok, response_payload} -> [3, id, response_payload]
          {:error, error} ->         [4, id, Atom.to_string(error), "", {}]
        end
      end

      def handle([3, id, payload]), do: IO.puts "Received answer for id \#{id}: \#{inspect(payload)}"
      def handle([4, id, err, desc, det]), do: IO.puts "Received error for id \#{id}: \#{err}, \#{desc}, \#{det}"

      def change_availability(_req), do: {:ok, %M.ChangeAvailabilityResponse{status: "Accepted"}}

      def unlock_connector(_req), do: {:ok, %M.UnlockConnectorResponse{status: "Unlocked"}}

    end
    ```
  """

  alias OcppModel.V20, as: M

  @callback change_availability(req :: ChangeAvailabilityRequest) :: ChangeAvailabilityResponse | {:error, :change_availability}
  @callback unlock_connector(req :: UnlockConnectorRequest) :: UnlockConnectorResponse | {:error, :unlock_connector}

  @spec handle(any(), String.t(), %{}) :: {:ok, %{}} | {:error, :atom}
  def handle(impl, "ChangeAvailability", payload), do: impl.change_availability(OcppModel.to_struct(M.ChangeAvailabilityRequest, payload))
  def handle(impl, "UnlockConnector", payload), do: impl.authorize(OcppModel.to_struct(M.UnlockConnectorRequest, payload))
  def handle(_impl, _action, _payload), do: {:error, :unknown_action}

end
