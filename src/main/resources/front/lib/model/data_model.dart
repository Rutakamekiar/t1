class DataModel {
  DataModel({
    this.host,
    this.result,
    this.message,
    this.at,
    this.bootTime,
    this.publicKey,
    this.agentVersion,
    this.cpu,
    this.disks,
    this.load,
    this.memory,
    this.network,
  });

  String host;
  int result;
  String message;
  String at;
  String bootTime;
  String publicKey;
  String agentVersion;
  List<Cpu> cpu;
  List<Disk> disks;
  List<double> load;
  Memory memory;
  List<Network> network;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        host: json["host"],
        result: json["result"] ?? 1,
        message: json["message"],
        at: json["at"],
        bootTime: json["boot_time"],
        publicKey: json["public_key"],
        agentVersion: json["agent_version"],
        cpu: List<Cpu>.from(json["cpu"].map((x) => Cpu.fromJson(x))),
        disks: List<Disk>.from(json["disks"].map((x) => Disk.fromJson(x))),
        load: List<double>.from(json["load"].map((x) => x.toDouble())),
        memory: Memory.fromJson(json["memory"]),
        network:
            List<Network>.from(json["network"].map((x) => Network.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "host": host,
        "result": result,
        "message": message,
        "at": at,
        "boot_time": bootTime,
        "public_key": publicKey,
        "agent_version": agentVersion,
        "cpu": List<dynamic>.from(cpu.map((x) => x.toJson())),
        "disks": List<dynamic>.from(disks.map((x) => x.toJson())),
        "load": List<dynamic>.from(load.map((x) => x)),
        "memory": memory.toJson(),
        "network": List<dynamic>.from(network.map((x) => x.toJson())),
      };
}

class Cpu {
  Cpu({
    this.num,
    this.user,
    this.system,
    this.idle,
  });

  int num;
  double user;
  double system;
  double idle;

  factory Cpu.fromJson(Map<String, dynamic> json) => Cpu(
        num: json["num"],
        user: json["user"].toDouble(),
        system: json["system"].toDouble(),
        idle: json["idle"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "num": num,
        "user": user,
        "system": system,
        "idle": idle,
      };
}

class Disk {
  Disk({
    this.origin,
    this.free,
    this.total,
  });

  String origin;
  int free;
  int total;

  factory Disk.fromJson(Map<String, dynamic> json) => Disk(
        origin: json["origin"],
        free: json["free"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "origin": origin,
        "free": free,
        "total": total,
      };
}

class Memory {
  Memory({
    this.wired,
    this.free,
    this.active,
    this.inactive,
    this.total,
  });

  int wired;
  int free;
  int active;
  int inactive;
  int total;

  factory Memory.fromJson(Map<String, dynamic> json) => Memory(
        wired: json["wired"],
        free: json["free"],
        active: json["active"],
        inactive: json["inactive"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "wired": wired,
        "free": free,
        "active": active,
        "inactive": inactive,
        "total": total,
      };
}

class Network {
  Network({
    this.name,
    this.networkIn,
    this.out,
  });

  String name;
  int networkIn;
  int out;

  factory Network.fromJson(Map<String, dynamic> json) => Network(
        name: json["name"],
        networkIn: json["in"],
        out: json["out"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "in": networkIn,
        "out": out,
      };
}
