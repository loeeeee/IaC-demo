# External Connectivity Endpoints
# ICMP ping checks to verify internet connectivity from backwater infrastructure
[
  # ============================================
  # Major Websites and Services (HTTP/HTTPS)
  # ============================================
  {
    name = "google";
    group = "internet connectivity";
    url = "https://www.google.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "github";
    group = "internet connectivity";
    url = "https://github.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "cloudflare";
    group = "internet connectivity";
    url = "https://www.cloudflare.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "amazon";
    group = "internet connectivity";
    url = "https://www.amazon.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "reddit";
    group = "internet connectivity";
    url = "https://www.reddit.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "wikipedia";
    group = "internet connectivity";
    url = "https://www.wikipedia.org";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "microsoft";
    group = "internet connectivity";
    url = "https://www.microsoft.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "apple";
    group = "internet connectivity";
    url = "https://www.apple.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "netflix";
    group = "internet connectivity";
    url = "https://www.netflix.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "youtube";
    group = "internet connectivity";
    url = "https://www.youtube.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "twitter";
    group = "internet connectivity";
    url = "https://x.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "nytimes";
    group = "internet connectivity";
    url = "https://www.nytimes.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "bbc";
    group = "internet connectivity";
    url = "https://www.bbc.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "stackexchange";
    group = "internet connectivity";
    url = "https://stackexchange.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "nixos";
    group = "internet connectivity";
    url = "https://nixos.org";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "archlinux";
    group = "internet connectivity";
    url = "https://archlinux.org";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "debian";
    group = "internet connectivity";
    url = "https://www.debian.org";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "ubuntu";
    group = "internet connectivity";
    url = "https://ubuntu.com";
    interval = "120s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
]
