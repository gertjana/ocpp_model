defmodule OcppModel.V20.Behaviours.Charger do
  @moduledoc """
    Behaviour of a Charger, allowing the module assuming the behaviour to be able to respond to messages send to it
  """

  alias OcppModel.V20.Messages, as: M

  @callback change_availability(req :: ChangeAvailabilityRequest)
              :: ChangeAvailabilityResponse | {:error, :change_availability}

  @callback data_transfer(req :: M.DataTransferRequest)
              :: {:ok, M.DataTransferResponse} | {:error, :data_transfer}

  @callback unlock_connector(req :: UnlockConnectorRequest)
              :: UnlockConnectorResponse | {:error, :unlock_connector}

  @spec handle(any(), String.t(), map()) :: {:ok, map()} | {:error, atom()}
  @doc """
    Main entrypoint, based on the action parameter, this function will call one of the callback functions
  """
  def handle(impl, action, payload) when action == "ChangeAvailability" do
    payload |> OcppModel.to_struct(M.ChangeAvailabilityRequest) |> impl.change_availability |> OcppModel.to_map()
  end

  def handle(impl, action, payload) when action == "DataTransfer" do
    payload |> OcppModel.to_struct(M.DataTransferRequest) |> impl.data_transfer |> OcppModel.to_map()
  end

  def handle(impl, action, payload) when action == "UnlockConnector" do
    payload |> OcppModel.to_struct(M.UnlockConnectorRequest) |> impl.unlock_connector |> OcppModel.to_map()
  end

  def handle(_impl, _action, _payload), do: {:error, :unknown_action}
end
