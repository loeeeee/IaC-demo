{ config, pkgs, lib, ... }:

{
  services.hadoop.package = pkgs.hadoop3;

  services.hadoop.coreSite = {
    "fs.defaultFS" = "hdfs://172.22.0.136:8020";
  };

  services.hadoop.hdfsSite = {
    "dfs.replication" = "2";
    "dfs.datanode.du.reserved" = "0";
  };

  services.hadoop.hdfs.datanode = {
    enable = true;
    dataDirs = [ { type = "DISK"; path = "/var/lib/hadoop/hdfs/datanode"; } ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/hadoop 0755 hdfs hadoop -"
    "d /var/lib/hadoop/hdfs 0755 hdfs hadoop -"
    "d /var/lib/hadoop/hdfs/datanode 0755 hdfs hadoop -"
  ];

}
