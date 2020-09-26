package com.e4developer.javalincakes;

public class Cpu {

    private String num;
    private String user;
    private String system;
    private String idle;

    public Cpu(String num, String user, String system, String idle) {
        this.num = num;
        this.user = user;
        this.system = system;
        this.idle = idle;
    }

    public String getNum() {
        return num;
    }

    public String getUser() {
        return user;
    }

    @Override
    public String toString() {
        return "Cpu{" +
                "num='" + num + '\'' +
                ", user='" + user + '\'' +
                ", system='" + system + '\'' +
                ", idle='" + idle + '\'' +
                '}';
    }

    public String getSystem() {
        return system;
    }

    public String getIdle() {
        return idle;
    }
}
