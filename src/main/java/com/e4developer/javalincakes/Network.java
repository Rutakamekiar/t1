package com.e4developer.javalincakes;

public class Network {

    private String name;
    private String in;
    private String out;

    public Network(String name, String in, String out) {
        this.name = name;
        this.in = in;
        this.out = out;
    }

    @Override
    public String toString() {
        return "Network{" +
                "name='" + name + '\'' +
                ", in='" + in + '\'' +
                ", out='" + out + '\'' +
                '}';
    }

    public String getName() {
        return name;
    }

    public String getIn() {
        return in;
    }

    public String getOut() {
        return out;
    }
}
