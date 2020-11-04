defmodule OcppModelMessagesTest do
  use ExUnit.Case
  use ExUnitProperties

  import StreamData

  alias OcppModel.V20.EnumTypes, as: ET
  alias OcppModel.V20.FieldTypes, as: FT
  alias OcppModel.V20.Messages, as: M

  defp string_of_len(opt, length) do
    gen all str <- string(opt), str != "", snipped = String.slice(str, 0..length), do: snipped
  end

  defp string_of_enum(enum_type) do
    gen all value <- StreamData.member_of(ET.get(enum_type)), do: value
  end

  defp date_time do
    gen all year <- integer(2000..2020), month <- integer(1..12 ), day <- integer(1..28),
            hour <- integer(0..23), minute <- integer(0..59), second <- integer(0..59) do
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

  defp heartbeat_response do
    gen all gen_datetime <- date_time() do
      %M.HeartbeatResponse{currentTime: gen_datetime}
    end
  end

  property :authorize_request do
    check all gen_auth_req <- authorize_request(), do: assert %M.AuthorizeRequest{} = gen_auth_req
  end

  property :boot_notification_request do
    check all gen_boot_req <- bootnotification_request(), do: assert %M.BootNotificationRequest{} = gen_boot_req
  end

  property :authorize_response do
    check all gen_auth_res <- authorize_response(), do: assert %M.AuthorizeResponse{} = gen_auth_res
  end

  property :heartbeat_response do
    check all gen_heartbeat_res <- heartbeat_response(), do: assert %M.HeartbeatResponse{} = gen_heartbeat_res
  end
end
