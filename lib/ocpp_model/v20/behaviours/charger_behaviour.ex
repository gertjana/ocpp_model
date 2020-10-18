defmodule OcppModel.V20.Behaviours.Charger do
  @moduledoc """
    Behaviour of a Charger, allowing the module assuming the behaviour to be able to respond to messages send to it

  """

  alias OcppModel.V20.Messages, as: M

  @callback change_availability(req :: ChangeAvailabilityRequest) :: ChangeAvailabilityResponse | {:error, :change_availability}
  @callback unlock_connector(req :: UnlockConnectorRequest) :: UnlockConnectorResponse | {:error, :unlock_connector}

  @spec handle(any(), String.t(), %{}) :: {:ok, %{}} | {:error, :atom}
  def handle(impl, "ChangeAvailability", payload), do: impl.change_availability(OcppModel.to_struct(M.ChangeAvailabilityRequest, payload))
  def handle(impl, "UnlockConnector", payload), do: impl.authorize(OcppModel.to_struct(M.UnlockConnectorRequest, payload))
  def handle(_impl, _action, _payload), do: {:error, :unknown_action}

end
