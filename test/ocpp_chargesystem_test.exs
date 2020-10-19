defmodule OcppModelChargeSystemTest do
  use ExUnit.Case

  alias OcppModel.V20.Behaviours, as: B
  alias OcppModel.V20.FieldTypes, as: FT
  alias OcppModel.V20.Messages, as: M

  defmodule MyTestChargeSystem do
    @behaviour B.ChargeSystem

    def handle([2, id, action, payload]) do
      case B.ChargeSystem.handle(__MODULE__, action, payload) do
        {:ok, response_payload} -> [3, id, response_payload]
        {:error, error} ->         [4, id, Atom.to_string(error), "", {}]
      end
    end
    def handle([3, id, payload]), do: IO.puts "Received answer for id #{id}: #{inspect(payload)}"
    def handle([4, id, err, desc, det]), do: IO.puts "Received error for id #{id}: #{err}, #{desc}, #{det}"

    @impl B.ChargeSystem
    def authorize(_req),  do: {:ok, %M.AuthorizeResponse{idTokenInfo: %FT.IdTokenInfoType{status: "Accepted"}}}

    @impl B.ChargeSystem
    def boot_notification(_req), do: {:ok, %M.BootNotificationResponse{currentTime: current_time()}}

    @impl B.ChargeSystem
    def heartbeat(_req), do: {:ok, %M.HeartbeatResponse{currentTime: current_time()}}

    @impl B.ChargeSystem
    def transaction_event(_req), do: {:ok, %M.TransactionEventResponse{}}

    def current_time, do: DateTime.now!("Etc/UTC") |> DateTime.to_iso8601()
  end

  test "MyTestChargeSystem.handle method should give a CallResult response when a correct Call message is given" do
    message = [2, "42", "Authorize", %{idToken: %{idToken: "", type: "NoAuthorization"}}]
    expected = [3, "42", %M.AuthorizeResponse{idTokenInfo: %FT.IdTokenInfoType{status: "Accepted"}}]
    assert expected == MyTestChargeSystem.handle(message)
  end

  test "MyTestChargeSystem.handle method should give a CallError response when a incorrect Call message is given" do
    message = [2, "42", "Unknown", %{}]
    expected = [4, "42", "unknown_action", "", {}]
    assert expected == MyTestChargeSystem.handle(message)
  end

  test "MyTestChargeSystem.authorize request should return a proper response" do
    request = %M.AuthorizeRequest{idToken: %FT.IdTokenType{idToken: "01020304", type: "ISO14443"}}
    {:ok, response} = MyTestChargeSystem.authorize(request)
    assert %M.AuthorizeResponse{} = response
    assert response.idTokenInfo.status == "Accepted"
  end

  test "MyTestChargeSystem.boot_nofitication request should return a proper response" do
    request = %M.BootNotificationRequest{reason: "Reboot",
      chargingStation: %FT.ChargingStationType{serialNumber: "GA-XC-001", vendorName: "GA", model: "XC"}}
    {:ok, response} = MyTestChargeSystem.boot_notification(request)
    assert %M.BootNotificationResponse{} = response
  end

  test "MyTestChargeSystem.heartbeat request should return a proper response" do
    request = %M.HeartbeatRequest{}
    {:ok, response} = MyTestChargeSystem.heartbeat(request)
    assert %M.HeartbeatResponse{} = response
  end

  test "MyTestChargerSystem.transaction_event request should return a proper response" do
    request = %M.TransactionEventRequest{eventType: "Started",
                                         timestamp: DateTime.now!("Etc/UTC") |> DateTime.to_iso8601(),
                                         triggerReason: "Authorized",
                                         seqNo: 0,
                                         transactionInfo: %FT.TransactionType{transactionId: "GA-XC-001_1"}}
    {:ok, response} = MyTestChargeSystem.transaction_event(request)
    assert %M.TransactionEventResponse{} = response
  end
end
