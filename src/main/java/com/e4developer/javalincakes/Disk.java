package com.e4developer.javalincakes;

public class Disk {

    private String origin;
    private String free;
    private String total;

    public Disk(String origin, String free, String total) {
        this.origin = origin;
        this.free = free;
        this.total = total;
    }

    @Override
    public String toString() {
        return "Disk{" +
                "origin='" + origin + '\'' +
                ", free='" + free + '\'' +
                ", total='" + total + '\'' +
                '}';
    }

    public String getOrigin() {
        return origin;
    }

    public String getFree() {
        return free;
    }

    public String getTotal() {
        return total;
    }
}
