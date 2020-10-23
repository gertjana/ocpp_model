# OcppModel
[![codecov](https://codecov.io/gh/gertjana/ocpp_model/branch/main/graph/badge.svg?token=nrXnKllzIA)](https://codecov.io/gh/gertjana/ocpp_model)
[![Build Status](https://travis-ci.com/gertjana/ocpp_model.svg?branch=main)](https://travis-ci.com/gertjana/ocpp_model)

Currently I'm running 2 experiments
 - An Ocpp Backend in Elixir
 - A Nerves based Charger on a Rasberry Pi Zero

This library contains the OCPP 2.x Model / Protocol that is needed for both those projects

It will be populated on a 'need to have' basis starting with basic charger functionality


## Installation

```elixir
def deps do
  [
    {:ocpp_model, "~> 0.1.0"}
  ]
end
```

## Usage

Using the library is by having your module assume either the `OcppModel.V20.Behaviours.Charger` or the `OcppModel.V20.Behaviours.ChargeSystem` Behaviour.

## An example Charger

```
  
  defmodule MyTestCharger do

    alias OcppModel.V20.Behaviours, as: B
    alias OcppModel.V20.FieldTypes, as: FT
    alias OcppModel.V20.Messages, as: M

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
```

## An Example ChargeSystem

```
  defmodule MyTestChargeSystem do

    alias OcppModel.V20.Behaviours, as: B
    alias OcppModel.V20.FieldTypes, as: FT
    alias OcppModel.V20.Messages, as: M

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
    def authorize(_req) do
      {:ok, %M.AuthorizeResponse{idTokenInfo: %FT.IdTokenInfoType{status: "Accepted"}}}
    end

    @impl B.ChargeSystem
    def boot_notification(_req) do
       {:ok, %M.BootNotificationResponse{currentTime: current_time(), interval: 900,
                                         status: %FT.StatusInfoType{reasonCode: ""}}}
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
```

