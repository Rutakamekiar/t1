package app.util;

import org.eclipse.jetty.server.session.SessionHandler;

import java.util.function.Supplier;

public class SessionUtils {

    public static Supplier<SessionHandler> customSessionHandlerSupplier() {
        final SessionHandler sessionHandler = new SessionHandler();
        sessionHandler.getSessionCookieConfig().setSecure(true);
        sessionHandler.getSessionCookieConfig().setComment("__SAME_SITE_STRICT__");
        return () -> sessionHandler;
    }

}
