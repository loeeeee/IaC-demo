# Aggregated endpoints from all group files
# This file imports and concatenates all endpoint definitions

import ./applications.nix ++
import ./auth.nix ++
import ./connectivity-internet.nix ++
import ./connectivity-intranet.nix ++
import ./data-processing.nix ++
import ./data-storage.nix ++
import ./haproxy.nix ++
import ./metrics.nix ++
import ./monitoring.nix ++
import ./networking.nix
