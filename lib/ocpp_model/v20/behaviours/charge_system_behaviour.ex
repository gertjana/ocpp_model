defmodule OcppModel.V20.Behaviours.ChargeSystem do
  @moduledoc """
    Behaviour of a ChargeSystem, allowing the module assuming the behaviour to be able to respond to messages send to it


  """
  alias OcppModel.V20.Messages, as: M

  @callback authorize(req :: AuthorizeRequest)
              :: {:ok, AuthorizeResponse} | {:error, :authorize}
  @callback boot_notification(req :: BootNotificationRequest)
              :: {:ok, BootNotificationResponse} | {:error, :boot_notification}
  @callback heartbeat(req :: HeartBeatRequest)
              :: {:ok, HeartbeatResponse} | {:error, :heartbeat}
  @callback transaction_event(req :: TransactionEventRequest)
              :: {:ok, TransactionEventResponse} | {:error, :transaction_event}

  @spec handle(any(), String.t(), %{}) :: {:ok, %{}} | {:error, :atom}
  @doc """
    Main entrypoint, based on the action parameter, this function will call one of the callback functions
  """
  def handle(impl, action, payload) when action == "Authorize",
    do: impl.authorize(OcppModel.to_struct(M.AuthorizeRequest, payload))
  def handle(impl, action, payload) when action == "BootNotification",
    do: impl.boot_notification(OcppModel.to_struct(M.BootNotificationRequest, payload))
  def handle(impl, action, payload) when action == "Heartbeat",
    do: impl.heartbeat(OcppModel.to_struct(M.HeartbeatRequest, payload))
  def handle(impl, action, payload) when action == "TransactionEvent",
    do: impl.transaction_event(OcppModel.to_struct(M.TransactionEventRequest, payload))
  def handle(_impl, _action, _payload), do: {:error, :unknown_action}

end
