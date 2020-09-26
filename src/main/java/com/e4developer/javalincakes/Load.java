package com.e4developer.javalincakes;

public class Load {

    public Load(float value1, float value2, float value3) {
        this.value1 = value1;
        this.value2 = value2;
        this.value3 = value3;
    }

    @Override
    public String toString() {
        return "Load{" +
                "value1=" + value1 +
                ", value2=" + value2 +
                ", value3=" + value3 +
                '}';
    }

    private float value1;
    private float value2;
    private float value3;

    public float getValue1() {
        return value1;
    }

    public float getValue2() {
        return value2;
    }

    public float getValue3() {
        return value3;
    }
}
