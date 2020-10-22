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

Have a look at 
```
/test/ocpp_charger_test.ex
/test/ocpp_chargesystem_test.ex
```
for an example on how to implement a Charger or ChargeSystem with this library


