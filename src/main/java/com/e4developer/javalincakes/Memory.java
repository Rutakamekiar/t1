package com.e4developer.javalincakes;

public class Memory {

    private String wired;
    private String free;
    private String active;
    private String inactive;
    private String total;

    public Memory(String wired, String free, String active, String inactive, String total) {
        this.wired = wired;
        this.free = free;
        this.active = active;
        this.inactive = inactive;
        this.total = total;
    }

    @Override
    public String toString() {
        return "Memory{" +
                "wired='" + wired + '\'' +
                ", free='" + free + '\'' +
                ", active='" + active + '\'' +
                ", inactive='" + inactive + '\'' +
                ", total='" + total + '\'' +
                '}';
    }

    public String getWired() {
        return wired;
    }

    public String getFree() {
        return free;
    }

    public String getActive() {
        return active;
    }

    public String getInactive() {
        return inactive;
    }

    public String getTotal() {
        return total;
    }
}
