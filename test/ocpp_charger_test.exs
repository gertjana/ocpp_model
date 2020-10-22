defmodule OcppModelChargerTest do
  use ExUnit.Case

  alias OcppModel.V20.Behaviours, as: B
  alias OcppModel.V20.FieldTypes, as: FT
  alias OcppModel.V20.Messages, as: M

  defmodule MyTestCharger do
    @behaviour B.Charger

    def handle([2, id, action, payload]) do
      case B.Charger.handle(MyTestCharger, action, payload) do
        {:ok, response_payload} -> [3, id, response_payload]
        {:error, error} ->         [4, id, Atom.to_string(error), "", {}]
      end
    end

    def handle([3, id, payload]), do: IO.puts "Received answer for id #{id}: #{inspect(payload)}"
    def handle([4, id, err, desc, det]), do: IO.puts "Received error for id #{id}: #{err}, #{desc}, #{det}"

    @impl B.Charger
    def change_availability(_req), do:
      {:ok, %M.ChangeAvailabilityResponse{status: "Accepted",
                                          statusInfo: %FT.StatusInfoType{reasonCode: "charger is inoperative"}}}

    @impl B.Charger
    def data_transfer(_req), do: {:ok, %M.DataTransferResponse{status: "Accepted"}}

    @impl B.Charger
    def unlock_connector(_req), do:
      {:ok, %M.UnlockConnectorResponse{status: "Unlocked",
                                       statusInfo: %FT.StatusInfoType{reasonCode: "cable unlocked"}}}

  end

  test "MyTestCharger.handle method should give a CallResult response when a ChangeAvailability Call message is given" do
    message = [2, "42", "ChangeAvailability", %{operationalStatus: "Inoperative", evse: 0}]
    expected = [3, "42", %{status: "Accepted", statusInfo: %{reasonCode: "charger is inoperative"}}]
    assert expected == MyTestCharger.handle(message)
  end

  test "MyTestCharger.handle method should give a CallResult response when a correct DataTransfer Call message is given" do
    message = [2, "42", "DataTransfer", %{messageId: "001", data: "All your base are belong to us", vendorId: "GA"}]
    assert [3, "42", %{status: "Accepted"}] = MyTestCharger.handle(message)
  end

  test "MyTestCharger.handle method should give a CallResult response when a UnlockConnector Call message is given" do
    message = [2, "42", "UnlockConnector", %{evseId: 0}]
    expected = [3, "42", %{status: "Unlocked", statusInfo: %{reasonCode: "cable unlocked"}}]
    assert expected == MyTestCharger.handle(message)
  end

  test "MyTestCharger.handle method should give a CallError response when a incorrect Call message is given" do
    message = [2, "42", "Unknown", %{}]
    expected = [4, "42", "unknown_action", "", {}]
    assert expected == MyTestCharger.handle(message)
  end

  test "MyTestCharger.change_availability request should return a proper response" do
    request = %M.ChangeAvailabilityRequest{operationalStatus: "Operative"}
    {:ok, response} = MyTestCharger.change_availability(request)
    assert %M.ChangeAvailabilityResponse{} = response
    assert response.status == "Accepted"
  end

  test "MyTestCharger.data_transfer request should return a proper response" do
    request = %M.DataTransferRequest{messageId: "001", data: "All your base are belong to us", vendorId: "GA"}
    {:ok, response} = MyTestCharger.data_transfer(request)
    assert %M.DataTransferResponse{} = response
  end

  test "MyTestCharger.unlock_connector request should return a proper response" do
    request = %M.UnlockConnectorRequest{evseId: 0}
    {:ok, response} = MyTestCharger.unlock_connector(request)
    assert %M.UnlockConnectorResponse{} = response
    assert response.status == "Unlocked"
  end

end
