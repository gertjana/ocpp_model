defmodule OcppModel.V20.Behaviours.Charger do
  @moduledoc """
    Behaviour of a Charger, allowing the module assuming the behaviour to be able to respond to messages send to it

  """

  alias OcppModel.V20.Messages, as: M

  @callback change_availability(req :: ChangeAvailabilityRequest)
              :: ChangeAvailabilityResponse | {:error, :change_availability}
  @callback unlock_connector(req :: UnlockConnectorRequest)
              :: UnlockConnectorResponse | {:error, :unlock_connector}

  @spec handle(any(), String.t(), %{}) :: {:ok, %{}} | {:error, :atom}
  @doc """
    Main entrypoint, based on the action parameter, this function will call one of the callback functions
  """
  def handle(impl, action, payload) when action == "ChangeAvailability", do:
    impl.change_availability(OcppModel.to_struct(M.ChangeAvailabilityRequest, payload))
  def handle(impl, action, payload) when action == "UnlockConnector", do:
    impl.unlock_connector(OcppModel.to_struct(M.UnlockConnectorRequest, payload))
  def handle(_impl, _action, _payload), do: {:error, :unknown_action}

end
