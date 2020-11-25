package app.activecheck;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;
import java.util.List;

public class ActiveCheck {
    public static int checkUrl(String link) throws IOException {
        URL url = new URL(link);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");
        int status = con.getResponseCode();
        return status;
    }

    public static void checkAllUrl() throws SQLException, IOException {
        List<String> urls = ActiveCheckDao.getAllUrls();
        if (!urls.isEmpty()){
            for (String url: urls) {
                int status = checkUrl(url);
                ActiveCheckDao.addResult(url,status);
            }
        }
    }
}
