defmodule OcppModelMessagesTest do
  @moduledoc """
    Property based testing for the OCPP Message Structs, for now just checks if the correct structs are generated,
    in the future they will be used to fire off these messages to both the charger and the backend

  """
  use ExUnit.Case
  use ExUnitProperties

  alias StreamData, as: SD

  alias OcppModel.V20.EnumTypes, as: ET
  alias OcppModel.V20.FieldTypes, as: FT
  alias OcppModel.V20.Messages, as: M

  defp string_of_len(opt, length) do
    gen all str <- SD.string(opt), str != "", snipped = String.slice(str, 0..length), do: snipped
  end

  defp string_of_enum(enum_type) do
    gen all value <- SD.member_of(ET.get(enum_type)), do: value
  end

  defp date_time do
    gen all year <- SD.integer(2000..2020), month <- SD.integer(1..12 ), day <- SD.integer(1..28),
            hour <- SD.integer(0..23), minute <- SD.integer(0..59), second <- SD.integer(0..59) do
      DateTime.new!(Date.new!(year, month, day), Time.new!(hour, minute, second, 0), "Etc/UTC")
        |> DateTime.to_iso8601()
    end
  end

  defp authorize_request do
    gen all id_token <- string_of_len(:ascii, 36),
            itet <- string_of_enum(:idTokenEnumType) do
      %M.AuthorizeRequest{idToken: %FT.IdTokenType{idToken: id_token, type: itet}}
    end
  end

  defp authorize_response do
    gen all gen_status <- string_of_enum(:authorizationStatusEnumType) do
      %M.AuthorizeResponse{idTokenInfo: %FT.IdTokenInfoType{status: gen_status}}
    end
  end

  defp bootnotification_request do
    gen all gen_reason <- string_of_enum(:bootReasonEnumType),
            gen_serial <- string_of_len(:ascii, 25),
            gen_model <- string_of_len(:ascii, 20),
            gen_vendor <- string_of_len(:ascii, 50),
            gen_firmware <- string_of_len(:ascii, 50),
            gen_iccid <- string_of_len(:ascii, 20),
            gen_imsi <- string_of_len(:ascii, 20) do
      %M.BootNotificationRequest{
        reason: gen_reason,
        chargingStation: %FT.ChargingStationType{
          serialNumber: gen_serial,
          model:  gen_model,
          vendorName: gen_vendor,
          firmwareVersion: gen_firmware,
          modem: %FT.ModemType{
            iccid: gen_iccid,
            imsi: gen_imsi
          }
        }
      }
    end
  end

  defp bootnotification_response do
    gen all gen_datetime <- date_time() do
      %M.BootNotificationResponse{
        currentTime: gen_datetime,
        interval: SD.integer(1..900),
        status: string_of_enum(:registrationStatusEnumType),
        statusInfo: %FT.StatusInfoType{
          reasonCode: string_of_len(:alphanumeric, 20),
          additionalInfo: string_of_len(:alphanumeric, 512)
        }
      }
    end
  end

  defp heartbeat_request do
    gen all _ <- nil do
      %M.HeartbeatRequest{}
    end
  end

  defp heartbeat_response do
    gen all gen_datetime <- date_time() do
      %M.HeartbeatResponse{currentTime: gen_datetime}
    end
  end

  defp meter_values_request do
    gen all gen_evse_id <- integer(),
            gen_meter_value_type <- meter_value_type() do
      %M.MeterValuesRequest{
        evseId: gen_evse_id,
        meterValue: gen_meter_value_type
      }
    end
  end

  defp meter_values_response do
    gen all _ <- nil do
      %M.MeterValuesResponse{}
    end
  end

  defp status_notification_request do
    gen all gen_datetime <- date_time(),
            gen_con_status <- string_of_enum(:connectorStatusEnumType),
            gen_evse_id <- SD.integer(0..10),
            gen_conn_id <- SD.integer(0..20) do
      %M.StatusNotificationRequest{
        timestamp: gen_datetime,
        connectorStatus: gen_con_status,
        evseId: gen_evse_id,
        connectorId: gen_conn_id
      }
    end
  end

  defp status_notification_response do
    gen all _ <- nil do
      %M.StatusNotificationResponse{}
    end
  end

  defp additional_info_type do
    gen all gen_add_info <- string_of_len(:alphanumeric, 36),
            gen_type <- string_of_len(:alphanumeric, 50) do
      %FT.AdditionalInfoType{
        additionalIdToken: gen_add_info,
        type: gen_type
      }
    end
  end

  defp meter_value_type do
    gen all gen_datetime <- date_time(),
            gen_value <- SD.float(),
            gen_context <- string_of_enum(:readingContextEnumType),
            gen_measurand <- string_of_enum(:measurerandEnumType),
            gen_phase <- string_of_enum(:phaseEnumType),
            gen_location <- string_of_enum(:locationEnumType),
            gen_signedmeterdata <- string_of_len(:alphanumeric, 2500),
            gen_signingmethod <- string_of_len(:alphanumeric, 50),
            gen_encodingmethod <- string_of_len(:alphanumeric, 50),
            gen_publickey <- string_of_len(:alphanumeric, 2500),
            gen_unit <- string_of_len(:alphanumeric, 20),
            gen_multiplier <- SD.integer() do
      %FT.MeterValueType{
        timestamp: gen_datetime,
        sampledValue: %FT.SampledValueType{
          value: gen_value,
          context: gen_context,
          measurand: gen_measurand,
          phase: gen_phase,
          location: gen_location,
          signedMeterValue: %FT.SignedMeterValueType{
            signedMeterData: gen_signedmeterdata,
            signingMethod: gen_signingmethod,
            encodingMethod: gen_encodingmethod,
            publicKey: gen_publickey
          },
          unitOfMeasure: %FT.UnitOfMeasureType{
            unit: gen_unit,
            multiplier: gen_multiplier
          }
        }
      }
    end
  end

  defp transactionevent_request do
    gen all gen_event_type <- string_of_enum(:transactionEventEnumType),
            gen_datetime <- date_time(),
            gen_trigger_reason <- string_of_enum(:triggerReasonEnumType),
            gen_seq_no <- SD.integer(),
            gen_transaction_id <- string_of_len(:alphanumeric, 36),
            gen_charging_state <- string_of_enum(:chargingStateEnumType),
            gen_time_spent_charging <- SD.integer(),
            gen_stopped_reason <- string_of_enum(:reasonEnumType),
            gen_remote_start_id <- SD.integer(),
            gen_id_token <- string_of_len(:alphanumeric, 36),
            gen_type <- string_of_enum(:idTokenEnumType),
            gen_additionalinfo <- list_of(additional_info_type()),
            gen_id <- SD.integer(),
            gen_conn_id <- SD.integer(),
            gen_meter_value_type <- meter_value_type() do
      %M.TransactionEventRequest{
        eventType: gen_event_type,
        timestamp: gen_datetime,
        triggerReason: gen_trigger_reason,
        seqNo: gen_seq_no,
        transactionInfo: %FT.TransactionType{
          transactionId: gen_transaction_id,
          chargingState: gen_charging_state,
          timeSpentCharging: gen_time_spent_charging,
          stoppedReason: gen_stopped_reason,
          remoteStartId: gen_remote_start_id
        },
        idToken: %FT.IdTokenType{
          idToken: gen_id_token,
          type: gen_type,
          additionalInfo: gen_additionalinfo
        },
        evse: %FT.EvseType{
          id: gen_id,
          connector_id: gen_conn_id
        },
        meterValue: gen_meter_value_type
      }
    end
  end

  defp transactionevent_response do
    gen all gen_total_cost <- SD.float(),
            gen_charging_prio <- SD.integer(-9..9),
            gen_status <- string_of_enum(:authorizationStatusEnumType),
            gen_format <- string_of_enum(:messageFormatEnumType),
            gen_language <- string_of_len(:alphanumeric, 8),
            gen_content <- string_of_len(:alphanumeric, 512) do
      %M.TransactionEventResponse{
        totalCost: gen_total_cost,
        chargingPriority: gen_charging_prio,
        idTokenInfo: %FT.IdTokenInfoType{
          status: gen_status
        },
        updatedPersonalMessage: %FT.MessageContentType{
          format: gen_format,
          language: gen_language,
          content: gen_content
        }
      }
    end
  end

  # property tests

  property :authorize_request do
    check all gen_auth_req <- authorize_request(),
      do: assert %M.AuthorizeRequest{} = gen_auth_req
  end

  property :authorize_response do
    check all gen_auth_res <- authorize_response(),
      do: assert %M.AuthorizeResponse{} = gen_auth_res
  end

  property :boot_notification_request do
    check all gen_boot_req <- bootnotification_request(),
      do: assert %M.BootNotificationRequest{} = gen_boot_req
  end

  property :boot_notification_response do
    check all gen_boot_res <- bootnotification_response(),
      do: assert %M.BootNotificationResponse{} = gen_boot_res
  end

  property :heartbeat_request do
    check all gen_hb_req <- heartbeat_request(),
      do: assert %M.HeartbeatRequest{} = gen_hb_req
  end

  property :heartbeat_response do
    check all gen_hb_res <- heartbeat_response(),
      do: assert %M.HeartbeatResponse{} = gen_hb_res
  end

  property :meter_values_request do
    check all gen_mv_req <- meter_values_request(),
      do: assert %M.MeterValuesRequest{} = gen_mv_req
  end

  property :meter_values_response do
    check all gen_mv_res <- meter_values_response(),
      do: assert %M.MeterValuesResponse{} = gen_mv_res
  end

  property :status_notification_request do
    check all gen_st_not_req <- status_notification_request(),
      do: assert %M.StatusNotificationRequest{} = gen_st_not_req
  end

  property :status_notification_response do
    check all gen_st_not_res <- status_notification_response(),
      do: assert %M.StatusNotificationResponse{} = gen_st_not_res
  end

  property :transaction_event_request do
    check all gen_trans_event_req <- transactionevent_request(),
      do: assert %M.TransactionEventRequest{} = gen_trans_event_req
  end

  property :transaction_event_response do
    check all gen_trans_event_res <- transactionevent_response(),
      do: assert %M.TransactionEventResponse{} = gen_trans_event_res
  end
end
