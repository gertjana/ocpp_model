defmodule OcppModelEnumerationsTest do
  use ExUnit.Case

  alias OcppModel.V20.EnumTypes, as: ET

  test "check valid enumeration" do
    assert ET.validate?(:TriggerReasonEnumType, "MeterValuePeriodic")
  end

  test "check wrong key enumeration" do
    assert ! ET.validate?(:UnknownEnumType, "Accepted")
  end

  test "check wrong value enumeration" do
    assert ! ET.validate?(:OperationalStatusEnumType, "CertificateExpired")
  end
end
