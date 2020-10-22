defmodule OcppModel.V20.Behaviours.ChargeSystem do
  @moduledoc """
    Behaviour of a ChargeSystem, allowing the module assuming the behaviour to be able to respond to messages send to it


  """
  alias OcppModel.V20.Messages, as: M

  @callback authorize(req :: M.AuthorizeRequest)
              :: {:ok, M.AuthorizeResponse}| {:error, :authorize}

  @callback boot_notification(req :: M.BootNotificationRequest)
              :: {:ok, M.BootNotificationResponse} | {:error, :boot_notification}

  @callback data_transfer(req :: M.DataTransferRequest)
              :: {:ok, M.DataTransferResponse} | {:error, :data_transfer}

  @callback heartbeat(req :: M.HeartBeatRequest)
              :: {:ok, M.HeartbeatResponse} | {:error, :heartbeat}

  @callback status_notification(req :: M.StatusNotificationRequest)
              :: {:ok, M.StatusNotificationResponse} | {:error, :status_notification}

  @callback transaction_event(req :: M.TransactionEventRequest)
              :: {:ok, M.TransactionEventResponse} | {:error, :transaction_event}

  @spec handle(any(), String.t(), %{}) :: {:ok, %{}} | {:error, :atom}
  @doc """
    Main entrypoint, based on the action parameter, this function will call one of the callback functions with the payload
  """
  def handle(impl, action, payload) when action == "Authorize" do
    payload |> OcppModel.to_struct(M.AuthorizeRequest) |> impl.authorize |> OcppModel.to_map()
  end

  def handle(impl, action, payload) when action == "BootNotification" do
    payload |> OcppModel.to_struct(M.BootNotificationRequest) |> impl.boot_notification |> OcppModel.to_map()
  end

  def handle(impl, action, payload) when action == "DataTransfer" do
    payload |> OcppModel.to_struct(M.DataTransferRequest) |> impl.data_transfer |> OcppModel.to_map()
  end

  def handle(impl, action, payload) when action == "Heartbeat" do
    payload |> OcppModel.to_struct(M.HeartbeatRequest) |> impl.heartbeat |> OcppModel.to_map()
  end

  def handle(impl, action, payload) when action == "StatusNotification" do
    payload |> OcppModel.to_struct(M.StatusNotificationRequest) |> impl.status_notification |> OcppModel.to_map()
  end

  def handle(impl, action, payload) when action == "TransactionEvent" do
    payload |> OcppModel.to_struct(M.TransactionEventRequest) |> impl.transaction_event |> OcppModel.to_map()
  end

  def handle(_impl, _action, _payload), do: {:error, :unknown_action}

end
