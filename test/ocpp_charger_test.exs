defmodule OcppModelChargerTest do
  use ExUnit.Case
  alias OcppModel.V20, as: M

  defmodule MyTestCharger do
    @behaviour M.Charger

    def handle([2, id, action, payload]) do
      case M.Charger.handle(MyTestCharger, action, payload) do
        {:ok, response_payload} -> [3, id, response_payload]
        {:error, error} ->         [4, id, Atom.to_string(error), "", {}]
      end
    end

    def handle([3, id, payload]), do: IO.puts "Received answer for id #{id}: #{inspect(payload)}"
    def handle([4, id, err, desc, det]), do: IO.puts "Received error for id #{id}: #{err}, #{desc}, #{det}"

    def change_availability(_req), do: {:ok, %M.ChangeAvailabilityResponse{status: "Accepted"}}

    def unlock_connector(_req), do: {:ok, %M.UnlockConnectorResponse{status: "Unlocked"}}

  end

  test "MyTestCharger handle method should give a CallResult response when a correct Call message is given" do
    message = [2, "42", "ChangeAvailability", %{operationalStatus: "Inoperative"}]
    expected = [3, "42", %OcppModel.V20.ChangeAvailabilityResponse{status: "Accepted"}]
    assert expected == MyTestCharger.handle(message)
  end

  test "MyTestCharger handle method should give a CallError response when a incorrect Call message is given" do
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

end
