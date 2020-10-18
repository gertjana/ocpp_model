defmodule OcppModel do
  @moduledoc """

  To create a ChargeSystem one must implement the OcppModel.V20.ChargeSystem

      defmodule MyTestChargeSystem do
        @behaviour OcppModel.V20.ChargeSystem

        def handle([2, id, action, payload]) do
          case OcppModel.V20.ChargeSystem.handle(__MODULE__, action, payload) do
            {:ok, response_payload} -> [3, id, response_payload]
            {:error, error} ->         [4, id, Atom.to_string(error), "", {}]
          end
        end
        def handle([3, id, payload]), do: IO.puts "Received answer for id \#{id}: \#{inspect(payload)}"
        def handle([4, id, err, desc, det]), do: IO.puts "Received error for id \#{id}: \#{err}, \#{desc}, \#{det}"

        @impl OcppModel.V20.ChargeSystem
        def authorize(_req),  do: {:ok, %OcppModel.V20.AuthorizeResponse{idTokenInfo: %OcppModel.V20.FieldTypes.IdTokenInfoType{status: "Accepted"}}}

        @impl OcppModel.V20.ChargeSystem
        def boot_notification(_req), do: {:ok, %OcppModel.V20.BootNotificationResponse{currentTime: current_time()}}

        @impl OcppModel.V20.ChargeSystem
        def heartbeat(_req), do: {:ok, %OcppModel.V20.HeartbeatResponse{currentTime: current_time()}}

        @impl OcppModel.V20.ChargeSystem
        def transaction_event(_req), do: {:ok, %OcppModel.V20.TransactionEventResponse{}}

        defp current_time(), do: DateTime.now!("Etc/UTC") |> DateTime.to_iso8601()
      end

  To create a Charger one must implement the OcppModel.V20.Charger


      defmodule MyTestCharger do
        @behaviour OcppModel.V20.Charger

        def handle([2, id, action, payload]) do
          case OcppModel.V20.Charger.handle(MyTestCharger, action, payload) do
            {:ok, response_payload} -> [3, id, response_payload]
            {:error, error} ->         [4, id, Atom.to_string(error), "", {}]
          end
        end
        def handle([3, id, payload]), do: IO.puts "Received answer for id \#{id}: \#{inspect(payload)}"
        def handle([4, id, err, desc, det]), do: IO.puts "Received error for id \#{id}: \#{err}, \#{desc}, \#{det}"

        def change_availability(_req), do: {:ok, %OcppModel.V20.ChangeAvailabilityResponse{status: "Accepted"}}

        def unlock_connector(_req), do: {:ok, %OcppModel.V20.UnlockConnectorResponse{status: "Unlocked"}}

      end




  """
  import OcppModel.V20

  def to_struct(kind, attrs) do
    struct = struct(kind)
    Enum.reduce Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end
  end
end
