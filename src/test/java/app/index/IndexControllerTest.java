package app.index;

import app.util.Path;
import io.javalin.http.Context;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PowerMockIgnore;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.Mockito.verify;

@RunWith(PowerMockRunner.class)
@PowerMockIgnore({"javax.management.*", "javax.script.*", "com.sun.org.apache.xerces.*", "javax.xml.*",
        "org.xml.*", "org.w3c.*"})
public class IndexControllerTest {

    @Test
    public void serveIndexPageTest() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);

        IndexController.serveIndexPage.handle(ctx);

        verify(ctx).render(Path.Template.INDEX);
    }

    @Test
    public void getRobotsTxtTest() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);

        IndexController.getRobotsTXT.handle(ctx);

        verify(ctx).result("# https://www.robotstxt.org/robotstxt.html\n" +
                "User-agent: *\n" +
                "Disallow:");
        verify(ctx).status(200);
    }
}