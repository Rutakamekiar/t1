package com.e4developer.javalincakes;

import java.util.Date;
import io.javalin.http.Context;

public final class GetRequestController {

    public GetRequestController(String host, String time, String bootTime, String publicKey, String agentVersion, //first values
                                String num, String user, String system, String idle, // for cpu`s object
                                String origin, String freeD, String totalD, //for disk`s object
                                float value1, float value2, float value3, //for load`s object
                                String wired, String freeM, String active, String inactive, String total,// for mem object
                                String name, String in, String out, //network
                                String nameN, String inN, String outN //networkN
                                ) {
        this.host = host;
        this.time = time;
        this.bootTime = bootTime;
        this.publicKey = publicKey;
        this.agentVersion = agentVersion;
        this.currCpu = new Cpu(num, user, system, idle);
        this.currDisk = new Disk(origin, freeD, totalD);
        this.currLoad = new Load(value1, value2, value3);
        this.currMem = new Memory(wired, freeM, active, inactive, total);
        this.currNetwork = new Network(name, in, out);
        this.currNetworkN = new Network(nameN, inN, outN);
    }

    private  String host;
    private String time;
    private String bootTime;
    private String publicKey;
    private String agentVersion;

    private Cpu currCpu;
    private Disk currDisk;
    private Load currLoad;
    private Memory currMem;
    private Network currNetwork;
    private Network currNetworkN;

    public String getHost() {
        return host;
    }

    public String getTime() {
        return time;
    }

    public String getBootTime() {
        return bootTime;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public String getAgentVersion() {
        return agentVersion;
    }

    public Cpu getCurrCpu() {
        return currCpu;
    }

    public Disk getCurrDisk() {
        return currDisk;
    }

    public Load getCurrLoad() {
        return currLoad;
    }

    public Memory getCurrMem() {
        return currMem;
    }

    public Network getCurrNetwork() {
        return currNetwork;
    }

    public Network getCurrNetworkN() {
        return currNetworkN;
    }

    @Override
    public String toString() {
        return "GetRequestController{" +
                "host='" + host + '\'' +
                ", time='" + time + '\'' +
                ", bootTime='" + bootTime + '\'' +
                ", publicKey='" + publicKey + '\'' +
                ", agentVersion='" + agentVersion + '\'' +
                ", currCpu=" + currCpu +
                ", currDisk=" + currDisk +
                ", currLoad=" + currLoad +
                ", currMem=" + currMem +
                ", currNetwork=" + currNetwork +
                ", currNetworkN=" + currNetworkN +
                '}';
    }
}
