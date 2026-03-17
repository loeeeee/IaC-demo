# Aggregated endpoints from all group files
# This file imports and concatenates all endpoint definitions

import ./applications.nix ++
import ./connectivity-internet.nix ++
import ./connectivity-intranet.nix ++
import ./haproxy.nix ++
import ./monitoring.nix ++
import ./networking.nix
