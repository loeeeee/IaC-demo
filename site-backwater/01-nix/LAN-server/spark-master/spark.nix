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

  systemd.services.spark-master = {
    description = "Apache Spark Standalone Master";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "hdfs-namenode.service" ];
    wants = [ "hdfs-namenode.service" ];
    path = [ pkgs.procps pkgs.bash pkgs.coreutils ];
    serviceConfig = {
      Type = "forking";
      Restart = "on-failure";
      User = "root";
    };
    environment = {
      SPARK_MASTER_HOST = "172.22.0.136";
      PYSPARK_PYTHON = "${pythonEnv}/bin/python3";
      SPARK_MASTER_PORT = "7077";
      SPARK_MASTER_WEBUI_PORT = "8080";
      SPARK_MASTER_OPTS = "-Dspark.ui.reverseProxy=true -Dspark.ui.reverseProxyUrl=https://spark.backwater.REDACTED-DOMAIN.TLD";
      SPARK_LOG_DIR = "/var/lib/spark/logs";
      SPARK_LOCAL_DIRS = "/var/lib/spark/work";
    };
    script = ''
      ${pkgs.spark}/bin/start-master.sh
    '';

    preStop = ''
      ${pkgs.spark}/bin/stop-master.sh
    '';
  };

  # Spark Connect

  systemd.services.spark-connect = {
  description = "Apache Spark Connect Server";
  wantedBy = [ "multi-user.target" ];
  after = [ "network.target" "spark-master.service" ];

  serviceConfig = {
    Type = "simple";
    Restart = "on-failure";
    User = "root";
    WorkingDirectory = "/var/lib/spark";
  };

  environment = {
    PATH = lib.mkForce (lib.makeBinPath [
      pkgs.bash
      pkgs.coreutils
      pkgs.procps
      pkgs.openjdk21
      pythonEnv
    ]);

    SPARK_LOG_DIR = "/var/lib/spark/logs";
    SPARK_LOCAL_DIRS = "/var/lib/spark/work";
    SPARK_HOME=pkgs.spark;
    PYSPARK_PYTHON = "${pythonEnv}/bin/python3";
  };

  script = ''
    exec ${pkgs.spark}/bin/spark-submit \
      --class org.apache.spark.sql.connect.service.SparkConnectServer \
      --name SparkConnectServer \
      --master spark://172.22.0.136:7077 \
      --conf spark.sql.session.localRelationChunkSizeRows=32768 \
      --conf spark.sql.session.localRelationChunkSizeBytes=33554432 \
      --conf spark.sql.session.localRelationBatchOfChunksSizeBytes=33554432 \
      --conf spark.connect.session.planCompression.threshold=2097152 \
      --conf spark.connect.session.planCompression.defaultAlgorithm=zstd \
      --conf spark.ui.reverseProxy=true \
      --conf spark.ui.reverseProxyUrl=https://spark.backwater.REDACTED-DOMAIN.TLD \
      spark-internal
  '';
  };
}