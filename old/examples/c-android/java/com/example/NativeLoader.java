package com.example;

public class NativeLoader extends android.app.NativeActivity {
    static {
        System.loadLibrary("main");
    }
}
