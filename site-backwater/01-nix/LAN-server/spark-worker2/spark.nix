{ config, pkgs, lib, ... }:

let
  pythonEnv = pkgs.python313.withPackages (ps: with ps; [
    numpy
    pandas
    pyarrow
    # Common packages
    scipy
    scikit-learn
    matplotlib
  ]);
in
{
  environment.systemPackages = with pkgs; [
    spark
    pythonEnv
  ];

  systemd.services.spark-worker = {
    description = "Apache Spark Standalone Worker";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "hdfs-datanode.service" ];
    wants = [ "hdfs-datanode.service" ];
    path = [ pythonEnv pkgs.procps pkgs.bash pkgs.coreutils ];
    serviceConfig = {
      Type = "forking";
      Restart = "on-failure";
      User = "root";
    };
    environment = {
      SPARK_LOCAL_IP = "172.22.0.138";
      SPARK_WORKER_PORT = "7079";
      SPARK_WORKER_WEBUI_PORT = "8081";
      SPARK_WORKER_OPTS = "-Dspark.ui.reverseProxy=true -Dspark.ui.reverseProxyUrl=https://spark.backwater.REDACTED-DOMAIN.TLD";
      SPARK_WORKER_DIR = "/var/lib/spark/work";
      SPARK_LOG_DIR = "/var/lib/spark/logs";
      SPARK_WORKER_MEMORY = "4g";
      PYSPARK_PYTHON = "${pythonEnv}/bin/python3";
    };
    script = ''
      ${pkgs.spark}/bin/start-worker.sh spark://172.22.0.136:7077
    '';

    preStop = ''
      ${pkgs.spark}/bin/stop-worker.sh
    '';
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/spark 0755 root root -"
    "d /var/lib/spark/work 0755 root root -"
    "d /var/lib/spark/logs 0755 root root -"
  ];
}
