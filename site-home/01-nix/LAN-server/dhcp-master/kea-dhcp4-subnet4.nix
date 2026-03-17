[
  # =============================================================================
  # LAN_Server subnet (172.21.0.0/24) - vmbr0
  # =============================================================================
  {
    "id" = 1;
    "subnet" = "172.21.0.0/24";
    "pools" = [
      { "pool" = "172.21.0.201 - 172.21.0.254"; }
    ];
    "reservations" = [
      # -------------------------------------------------------------------------
      # Legacy Machines (Infrastructure)
      # -------------------------------------------------------------------------
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.2";
        "hostname" = "bell";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.3";
        "hostname" = "lava";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.4";
        "hostname" = "shroomlight";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.5";
        "hostname" = "minecart";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.11";
        "hostname" = "bedrock";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.23";
        "hostname" = "gemini";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.24";
        "hostname" = "cancer";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.25";
        "hostname" = "leo";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.26";
        "hostname" = "virgo";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.27";
        "hostname" = "libra";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.28";
        "hostname" = "scorpio";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.29";
        "hostname" = "sagittarius";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.31";
        "hostname" = "aquarius";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.32";
        "hostname" = "pisces";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.41";
        "hostname" = "alameda";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.42";
        "hostname" = "alpine";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.43";
        "hostname" = "amador";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.45";
        "hostname" = "calaveras";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.46";
        "hostname" = "colusa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.47";
        "hostname" = "contracosta";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.48";
        "hostname" = "delnorte";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.49";
        "hostname" = "eldorado";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.50";
        "hostname" = "fresno";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.51";
        "hostname" = "gleen";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.60";
        "hostname" = "cs-kafka";
      }
      # -------------------------------------------------------------------------
      # Reserved Static Mappings - Tokyo Special Wards (172.21.0.101-200)
      # MAC Pattern: BC:24:11:21:01:XX where XX = IP_last_octet - 100
      # -------------------------------------------------------------------------
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.101";
        "hostname" = "suginami";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.102";
        "hostname" = "itabashi";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.103";
        "hostname" = "hachioji";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.104";
        "hostname" = "koto";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.105";
        "hostname" = "katsushika";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.106";
        "hostname" = "machida";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.107";
        "hostname" = "shinagawa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.108";
        "hostname" = "kita";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.109";
        "hostname" = "shinjuku";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.110";
        "hostname" = "nakano";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.111";
        "hostname" = "toshima";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.112";
        "hostname" = "meguro";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.113";
        "hostname" = "sumida";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.114";
        "hostname" = "fuchu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.115";
        "hostname" = "minato";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.116";
        "hostname" = "shibuya";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.117";
        "hostname" = "chofu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.118";
        "hostname" = "bunkyo";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.119";
        "hostname" = "arakawa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.120";
        "hostname" = "taito";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.121";
        "hostname" = "nishitokyo";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.122";
        "hostname" = "kodaira";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.123";
        "hostname" = "mitaka";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.124";
        "hostname" = "hino";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.125";
        "hostname" = "tachikawa";
      }
      # Existing NixOS containers (126-130)
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.126";
        "hostname" = "setagaya";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.127";
        "hostname" = "nerima";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.128";
        "hostname" = "ota";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.129";
        "hostname" = "edogawa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.130";
        "hostname" = "adachi";
      }
      # Continuing Tokyo cities (131-200)
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.131";
        "hostname" = "chuo";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.132";
        "hostname" = "higashimurayama";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.133";
        "hostname" = "musashino";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.134";
        "hostname" = "tama";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.135";
        "hostname" = "ome";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.136";
        "hostname" = "kokubunji";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.137";
        "hostname" = "koganei";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.138";
        "hostname" = "higashikurume";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.139";
        "hostname" = "akishima";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.140";
        "hostname" = "inagi";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.141";
        "hostname" = "komae";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.142";
        "hostname" = "higashiyamato";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.143";
        "hostname" = "akiruno";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.144";
        "hostname" = "kunitachi";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.145";
        "hostname" = "kiyose";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.146";
        "hostname" = "musashimurayama";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.147";
        "hostname" = "chiyoda";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.148";
        "hostname" = "fussa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.149";
        "hostname" = "hamura";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.150";
        "hostname" = "mizuho";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.151";
        "hostname" = "hinode";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.152";
        "hostname" = "okutama";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.153";
        "hostname" = "oshima";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.154";
        "hostname" = "hachijo";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.155";
        "hostname" = "ogasawara";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.156";
        "hostname" = "niijima";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.157";
        "hostname" = "miyake";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.158";
        "hostname" = "hinohara";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.159";
        "hostname" = "kozushima";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.160";
        "hostname" = "toshima-village";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.161";
        "hostname" = "mikurajima";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.0.162";
        "hostname" = "aogashima";
      }
    ];
    "option-data" = [
      {
        "name" = "routers";
        "data" = "172.21.0.1";
      }
      {
        "name" = "domain-name-servers";
        "data" = "172.21.0.50";
      }
      {
        "name" = "domain-name";
        "data" = "home.REDACTED-DOMAIN.TLD";
      }
      {
        "name" = "ntp-servers";
        "data" = "172.21.0.1";
      }
      {
        "name" = "domain-search";
        "data" = "home.REDACTED-DOMAIN.TLD";
      }
    ];
  }

  # =============================================================================
  # LAN_Client subnet (172.21.3.0/24) - vmbr1
  # =============================================================================
  {
    "id" = 2;
    "subnet" = "172.21.3.0/24";
    "pools" = [
      { "pool" = "172.21.3.151 - 172.21.3.254"; }
    ];
    "reservations" = [
      # -------------------------------------------------------------------------
      # Legacy Machines (Infrastructure)
      # -------------------------------------------------------------------------
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.2";
        "hostname" = "bell";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.3";
        "hostname" = "lava";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.4";
        "hostname" = "shroomlight";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.5";
        "hostname" = "minecart";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.7";
        "hostname" = "router5";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.13";
        "hostname" = "andesite-1";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.14";
        "hostname" = "andesite-2";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.15";
        "hostname" = "cobblestone";
      }
      # -------------------------------------------------------------------------
      # Reserved Static Mappings - Shimane Prefecture (172.21.3.101-150)
      # MAC Pattern: BC:24:11:21:03:XX where XX = IP_last_octet - 100
      # -------------------------------------------------------------------------
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.101";
        "hostname" = "matsue";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.102";
        "hostname" = "izumo";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.103";
        "hostname" = "hamada";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.104";
        "hostname" = "masuda";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.105";
        "hostname" = "yasugi";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.106";
        "hostname" = "unnan";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.107";
        "hostname" = "oda";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.108";
        "hostname" = "gotsu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.109";
        "hostname" = "okinoshima";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.110";
        "hostname" = "okuizumo";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.111";
        "hostname" = "onan";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.112";
        "hostname" = "tsuwano";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.113";
        "hostname" = "yoshika";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.114";
        "hostname" = "iinan";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.115";
        "hostname" = "misato";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.116";
        "hostname" = "kawamoto";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.117";
        "hostname" = "nishinoshima";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.118";
        "hostname" = "ama";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.3.119";
        "hostname" = "chibu";
      }
    ];
    "option-data" = [
      {
        "name" = "routers";
        "data" = "172.21.3.1";
      }
      {
        "name" = "domain-name-servers";
        "data" = "172.21.0.50";
      }
      {
        "name" = "domain-name";
        "data" = "home.REDACTED-DOMAIN.TLD";
      }
      {
        "name" = "ntp-servers";
        "data" = "172.21.3.1";
      }
      {
        "name" = "domain-search";
        "data" = "home.REDACTED-DOMAIN.TLD";
      }
    ];
  }

  # =============================================================================
  # DMZ subnet (172.21.1.0/24) - vmbr5
  # =============================================================================
  {
    "id" = 3;
    "subnet" = "172.21.1.0/24";
    "pools" = [
      { "pool" = "172.21.1.201 - 172.21.1.254"; }
    ];
    "reservations" = [
      # -------------------------------------------------------------------------
      # Legacy Machines
      # -------------------------------------------------------------------------
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.10";
        "hostname" = "mercury";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.11";
        "hostname" = "venus";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.12";
        "hostname" = "earth";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.13";
        "hostname" = "mars";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.14";
        "hostname" = "jupiter";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.15";
        "hostname" = "saturn";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.16";
        "hostname" = "uranus";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.17";
        "hostname" = "neptune";
      }
      # -------------------------------------------------------------------------
      # Reserved Static Mappings - Hokkaido (172.21.1.101-200)
      # MAC Pattern: BC:24:11:21:05:XX where XX = IP_last_octet - 100
      # -------------------------------------------------------------------------
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.101";
        "hostname" = "sapporo";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.102";
        "hostname" = "asahikawa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.103";
        "hostname" = "hakodate";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.104";
        "hostname" = "tomakomai";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.105";
        "hostname" = "obihiro";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.106";
        "hostname" = "kushiro";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.107";
        "hostname" = "ebetsu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.108";
        "hostname" = "kitami";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.109";
        "hostname" = "otaru";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.110";
        "hostname" = "chitose";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.111";
        "hostname" = "muroran";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.112";
        "hostname" = "iwamizawa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.113";
        "hostname" = "eniwa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.114";
        "hostname" = "kitahiroshima";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.115";
        "hostname" = "ishikari";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.116";
        "hostname" = "noboribetsu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.117";
        "hostname" = "hokuto";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.118";
        "hostname" = "otofuke";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.119";
        "hostname" = "takikawa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.120";
        "hostname" = "abashiri";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.121";
        "hostname" = "wakkanai";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.122";
        "hostname" = "date";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.123";
        "hostname" = "nanae";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.124";
        "hostname" = "nayoro";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.125";
        "hostname" = "makubetsu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.126";
        "hostname" = "nemuro";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.127";
        "hostname" = "nakashibetsu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.128";
        "hostname" = "shinhidaka";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.129";
        "hostname" = "mombetsu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.130";
        "hostname" = "furano";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.131";
        "hostname" = "bibai";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.132";
        "hostname" = "rumoi";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.133";
        "hostname" = "fukagawa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.134";
        "hostname" = "engaru";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.135";
        "hostname" = "bihoro";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.136";
        "hostname" = "memuro";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.137";
        "hostname" = "yoichi";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.138";
        "hostname" = "shibetsu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.139";
        "hostname" = "sunagawa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.140";
        "hostname" = "shiraoi";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.141";
        "hostname" = "tobetsu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.142";
        "hostname" = "yakumo";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.143";
        "hostname" = "kutchan";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.144";
        "hostname" = "betsukai";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.145";
        "hostname" = "mori";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.146";
        "hostname" = "ashibetsu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.147";
        "hostname" = "urakawa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.148";
        "hostname" = "iwanai";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.149";
        "hostname" = "shari";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.150";
        "hostname" = "hidaka";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.151";
        "hostname" = "kuriyama";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.152";
        "hostname" = "kamifurano";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.153";
        "hostname" = "naganuma";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.154";
        "hostname" = "higashikagura";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.155";
        "hostname" = "biei";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.156";
        "hostname" = "akabira";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.157";
        "hostname" = "shimizu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.158";
        "hostname" = "akkeshi";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.159";
        "hostname" = "toyako";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.160";
        "hostname" = "yubetsu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.161";
        "hostname" = "higashikawa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.162";
        "hostname" = "mikasa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.163";
        "hostname" = "esashi";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.164";
        "hostname" = "mukawa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.165";
        "hostname" = "abira";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.166";
        "hostname" = "setana";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.167";
        "hostname" = "shiranuka";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.168";
        "hostname" = "nanporo";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.169";
        "hostname" = "yubari";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.170";
        "hostname" = "shibecha";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.171";
        "hostname" = "ozora";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.172";
        "hostname" = "teshikaga";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.173";
        "hostname" = "takasu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.174";
        "hostname" = "matsumae";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.175";
        "hostname" = "honbetsu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.176";
        "hostname" = "ashoro";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.177";
        "hostname" = "haboro";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.178";
        "hostname" = "shintotsukawa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.179";
        "hostname" = "hiroo";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.180";
        "hostname" = "ikeda";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.181";
        "hostname" = "toma";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.182";
        "hostname" = "shihoro";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.183";
        "hostname" = "shintoku";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.184";
        "hostname" = "kyowa";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.185";
        "hostname" = "hamanaka";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.186";
        "hostname" = "taiki";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.187";
        "hostname" = "niikappu";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.188";
        "hostname" = "shikaoi";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.189";
        "hostname" = "naie";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.190";
        "hostname" = "oshamambe";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.191";
        "hostname" = "imakane";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.192";
        "hostname" = "niseko";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.193";
        "hostname" = "kamishihoro";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.194";
        "hostname" = "saroma";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.195";
        "hostname" = "yuni";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.196";
        "hostname" = "nakafurano";
      }
      {
        "hw-address" = "REDACTED";
        "ip-address" = "172.21.1.197";
        "hostname" = "kunneppu";
      }
    ];
    "option-data" = [
      {
        "name" = "routers";
        "data" = "172.21.1.1";
      }
      {
        "name" = "domain-name-servers";
        "data" = "172.21.0.50";
      }
      {
        "name" = "domain-name";
        "data" = "home.REDACTED-DOMAIN.TLD";
      }
      {
        "name" = "ntp-servers";
        "data" = "172.21.1.1";
      }
    ];
  }
]
