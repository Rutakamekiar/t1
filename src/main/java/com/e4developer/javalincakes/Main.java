package com.e4developer.javalincakes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.javalin.Javalin;

public class Main {
    public static void main(String[] args)  {
        Javalin app = Javalin.create().start(7777);




        GetRequestController curr= new GetRequestController(
                "potapuff.example.com", "2020-09-10 19:20:09 +0300", "2020-07-27 19:45:52 +0300",
                "my-host-name", "0.1.0", "0", "0.07", "0.09", "99.84",
                "/dev/disk0s2", "4283908096", "15448670208", 0.06f, 0.012f, 0.09f,
                "106999808", "7292", "196837376", "176910336", "510615552",
                "ens3", "125246311189", "2563164190", "lo", "1029238373", "1029238373");

        app.get("/", ctx -> ctx.result(curr.toString()));



        //app.get("/cakes", CakesController::getAllCakes);

        //app.get("/cakes/:special", CakesController::getSpecialCake);
    }
}
