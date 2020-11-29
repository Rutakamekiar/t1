package app.util;

/**
 * Contain paths of api and page resources
 * @author Kotelevsky Kirill
 * @version 1.0
 */
public class Path {

    /**
     * Contain paths of api
     */
    public static class Web {
        public static final String INDEX = "/index";
        public static final String LOGIN = "/login";
        public static final String LOGOUT = "/logout";
        public static final String AGENTMSG = "/api/endpoint";
        public static final String GETAGENTMSG = "/getmsg";
        public static final String SIGNIN = "/signin";
        public static final String REGISTER = "/register";
        public static final String REGISTER_WITH_LOC = "/registerWithLoc";
        public static final String VERIFICATE = "/email_verificate";
        public static final String DROPPWD = "/droppwd";
        public static final String DROPPWD_WITH_LOC = "/droppwdWithLoc";
        public static final String GETUSERSERVERS = "/getServers";
        public static final String ADDSERVERTOUSER = "/addServer";
        public static final String DELETESERVERFROMUSER = "/deleteServer";
        public static final String ISLOGIN = "/isLogin";
        public static final String ROBOTSTXT = "/robots.txt";
        public static final String GETAVATAR = "/getavatar";
        public static final String SETAVATAR = "/setavatar";
        public static final String GETALLUSERSADMIN = "/getallusersadmin";
        public static final String ADMINSETFREE = "/adminsetfree";
        public static final String ADMINSETPREMIUM = "/adminsetpremium";
        public static final String ADMINDROPAVATAR = "/admindropavatar";
        public static final String DROPUSERHOSTS = "/dropuserhosts";
        public static final String GENERATEKEYS = "/tools/generateKeys";
        public static final String GETPREMIUM = "/getPremium";


        public static final String ADD_URL = "/addUrl";
        public static final String GET_UPTIME = "/getUptime";
        public static final String DELETE_URL = "/deleteUrl";
    }
    /**
     * Contain paths of page resources
     */
    public static class Template {
        public static final String INDEX = "/front/build/web/index.html";
        public static final String LOGIN = "/velocity/login/login.vm";
        public static final String NOT_FOUND = "/velocity/notFound.vm";
    }

}
