package app.util;

import app.util.Path;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.net.URLClassLoader;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class PathTest {

    @Test
    public void testFunk_CheckIsPageBelongsToPathsGroup() throws IllegalAccessException, InstantiationException, ClassNotFoundException, IOException {
        assertTrue(Path.checkIsPageBelongsToPathsGroup("/index", new Path.WebUnloginnedAccess()));
        assertTrue(Path.checkIsPageBelongsToPathsGroup("/indexsafd",new Path.WebUnloginnedAccess()));
        assertTrue(Path.checkIsPageBelongsToPathsGroup("/getServers",new Path.WebLogInnedAccess()));
        assertTrue(Path.checkIsPageBelongsToPathsGroup("/getServersaeawad",new Path.WebLogInnedAccess()));
        assertFalse(Path.checkIsPageBelongsToPathsGroup("/index",new Path.WebLogInnedAccess()));
        assertFalse(Path.checkIsPageBelongsToPathsGroup("/indexasdf",new Path.WebLogInnedAccess()));
        assertFalse(Path.checkIsPageBelongsToPathsGroup("/getServers",new Path.WebUnloginnedAccess()));
        assertFalse(Path.checkIsPageBelongsToPathsGroup("/getServersadfaqw",new Path.WebUnloginnedAccess()));
    }

}
