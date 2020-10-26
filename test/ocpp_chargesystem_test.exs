defmodule OcppModelChargeSystemTest do
  use ExUnit.Case

  alias OcppModel.V20.Behaviours, as: B
  alias OcppModel.V20.EnumTypes,  as: ET
  alias OcppModel.V20.FieldTypes, as: FT
  alias OcppModel.V20.Messages,   as: M

  defmodule MyTestChargeSystem do
    @behaviour B.ChargeSystem

    def handle([2, id, action, payload]) do
      case B.ChargeSystem.handle(__MODULE__, action, payload) do
        {:ok, response_payload} -> [3, id, response_payload]
        {:error, error, desc} -> [4, id, Atom.to_string(error), desc, {}]
      end
    end
    def handle([3, id, payload]), do: IO.puts "Received answer for id #{id}: #{inspect(payload)}"
    def handle([4, id, err, desc, det]), do: IO.puts "Received error for id #{id}: #{err}, #{desc}, #{det}"

    @impl B.ChargeSystem
    def authorize(_req) do
      {:ok, %M.AuthorizeResponse{idTokenInfo: %FT.IdTokenInfoType{status: "Accepted"}}}
    end

    @impl B.ChargeSystem
    def boot_notification(req) do
      if ET.validate?(:bootReasonEnumType, req.reason) do
        {:ok, %M.BootNotificationResponse{currentTime: current_time(), interval: 900,
                status: %FT.StatusInfoType{reasonCode: ""}}}
      else
        {:error, :invalid_bootreason, "#{req.reason} is not a valid BootReason"}
      end
    end

    @impl B.ChargeSystem
    def data_transfer(req) do
      case req.vendorId do
        "GA" -> {:ok, %M.DataTransferResponse{status: "Accepted", data: String.reverse(req.data)}}
        _ -> {:ok, %M.DataTransferResponse{status: "UnknownVendorId"}}
      end
    end

    @impl B.ChargeSystem
    def heartbeat(_req) do
      {:ok, %M.HeartbeatResponse{currentTime: current_time()}}
    end

    @impl B.ChargeSystem
    def status_notification(_req) do
      {:ok, %M.StatusNotificationResponse{}}
    end

    @impl B.ChargeSystem
    def transaction_event(_req) do
      {:ok, %M.TransactionEventResponse{}}
    end

    def current_time, do: DateTime.now!("Etc/UTC") |> DateTime.to_iso8601()
  end

  @tr_ev_request %{
                    eventType: "Started",
                    timestamp: DateTime.now!("Etc/UTC") |> DateTime.to_iso8601(),
                    triggerReason: "Authorized",
                    seqNo: 0,
                    transactionInfo: %FT.TransactionType{transactionId: "GA-XC-001_1"},
                    evse: %FT.EvseType{id: 1, connector_id: 2},
                    meterValue: %FT.MeterValueType{
                      timestamp: DateTime.now!("Etc/UTC") |> DateTime.to_iso8601(),
                      sampledValue: %FT.SampledValueType{value: 12.34,
                        signedMeterValue: %FT.SignedMeterValueType{
                          signedMeterData: "blabla",
                          signingMethod: "SHA256",
                          encodingMethod: "GZ",
                          publicKey: "something public something"
                        },
                        unitOfMeasure: %FT.UnitOfMeasureType{
                          unit: "kWh",
                          multiplier: 0
                        }
                      }
                    }
                  }
  @boot_not_request %{
                      reason: "PowerUp",
                      chargingStation: %FT.ChargingStationType{
                        serialNumber: "GA-XC-001",
                        vendorName: "GA",
                        model: "XC"
                      }
                    }
  @auth_request %{
                  idToken: %FT.IdTokenType{
                    idToken: "",
                    type: "NoAuthorization",
                    additionalInfo: %FT.AdditionalInfoType{
                      additionalIdToken: "123456",
                      type: "OTP"
                    }
                  }
                }

  test "MyTestChargeSystem.handle should give a CallResult response when a correct Authorize Call message is given" do
    message = [2, "42", "Authorize", @auth_request]
    assert [3, "42", %{idTokenInfo: %{status: "Accepted"}}] == MyTestChargeSystem.handle(message)
  end

  test "MyTestChargeSystem.handle should give a CallResult response when a correct BootNotification Call message is given" do
    message = [2, "42", "BootNotification", @boot_not_request]
    assert [3, "42", %{currentTime: _}] = MyTestChargeSystem.handle(message)
  end

  test "MyTestChargeSystem.handle should give a CallResult response when a correct DataTransfer Call message is given" do
    message = [2, "42", "DataTransfer", %{messageId: "001", data: "All your base are belong to us", vendorId: "GA"}]
    assert [3, "42", %{status: "Accepted", data: "su ot gnoleb era esab ruoy llA"}] = MyTestChargeSystem.handle(message)
  end

  test "MyTestChargeSystem.handle should give a CallResult response when a correct Heartbeat Call message is given" do
    message = [2, "42", "Heartbeat", %{}]
    assert [3, "42", %{currentTime: _}] = MyTestChargeSystem.handle(message)
  end

  test "MyTestChargeSystem.handle should give a CallResult response when a correct StatusNotification Call message is given" do
    message = [2, "42", "StatusNotification", %{timestamp: DateTime.now!("Etc/UTC") |> DateTime.to_iso8601(),
                                                connectorStatus: "Available", evseId: 0, connectorId: 0}]
    assert [3, "42", %{}] = MyTestChargeSystem.handle(message)
  end

  test "MyTestChargeSystem.handle should give a CallResult response when a correct TransactionEvent Call message is given" do
    message = [2, "42", "TransactionEvent",  @tr_ev_request]
    assert [3, "42", %{}] = MyTestChargeSystem.handle(message)
  end

  test "MyTestChargeSystem.handle should give a CallError response when a incorrect Call message is given" do
    message = [2, "42", "Unknown", %{}]
    expected = [4, "42", "unknown_action", "Action Unknown is unknown", {}]
    assert expected = MyTestChargeSystem.handle(message)
  end

  # Individual tests on callback methods

  test "MyTestChargeSystem.authorize request should return a proper response" do
    request = %M.AuthorizeRequest{idToken: %FT.IdTokenType{idToken: "01020304", type: "ISO14443"}}
    {:ok, response} = MyTestChargeSystem.authorize(request)
    assert %M.AuthorizeResponse{} = response
    assert response.idTokenInfo.status == "Accepted"
  end

  test "MyTestChargeSystem.boot_nofitication request should return a proper response" do
    {:ok, response} = MyTestChargeSystem.boot_notification(@boot_not_request)
    assert %M.BootNotificationResponse{} = response
  end

  test "MyTestChargeSystem.data_transfer request should return a proper response" do
    request = %M.DataTransferRequest{messageId: "001", data: "All your base are belong to us", vendorId: "GA"}
    {:ok, response} = MyTestChargeSystem.data_transfer(request)
    assert %M.DataTransferResponse{} = response
  end

  test "MyTestChargeSystem.heartbeat request should return a proper response" do
    request = %M.HeartbeatRequest{}
    {:ok, response} = MyTestChargeSystem.heartbeat(request)
    assert %M.HeartbeatResponse{} = response
  end

  test "MyTestChargerSystem.transaction_event request should return a proper response" do
    request = @tr_ev_request
    {:ok, response} = MyTestChargeSystem.transaction_event(request)
    assert %M.TransactionEventResponse{} = response
  end
end
