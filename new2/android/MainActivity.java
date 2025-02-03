package {{ PACKAGE }};

public class MainActivity extends android.app.NativeActivity {
    static {
        System.loadLibrary("main");
    }
}
