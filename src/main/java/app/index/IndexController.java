package app.index;

import io.javalin.http.Handler;

import java.io.File;
import java.io.FileReader;
import java.util.Map;

import app.util.Path;
import app.util.ViewUtil;

import static app.Main.*;

public class IndexController {
    public static Handler serveIndexPage = ctx -> {
        ctx.render(Path.Template.INDEX);
    };


    public static Handler getRobotsTXT = ctx -> {
        String result = "# https://www.robotstxt.org/robotstxt.html\n" +
                "User-agent: *\n" +
                "Disallow:";
        ctx.result(result);
        ctx.status(200);
    };
}
