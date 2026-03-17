{ config, pkgs, lib, ... }:

{
  services.hadoop.package = pkgs.hadoop3;

  services.hadoop.coreSite = {
    "fs.defaultFS" = "hdfs://172.22.0.136:8020";
  };

  services.hadoop.hdfsSite = {
    "dfs.replication" = "2";
    "dfs.namenode.name.dir" = "file:///var/lib/hadoop/hdfs/namenode";
    "dfs.namenode.resource.du.reserved" = "0";
    "dfs.namenode.datanode.registration.ip-hostname-check" = "false";
  };

  services.hadoop.hdfs.namenode = {
    enable = true;
    formatOnInit = false;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/hadoop 0755 hdfs hadoop -"
    "d /var/lib/hadoop/hdfs 0755 hdfs hadoop -"
    "d /var/lib/hadoop/hdfs/namenode 0755 hdfs hadoop -"
  ];
}
