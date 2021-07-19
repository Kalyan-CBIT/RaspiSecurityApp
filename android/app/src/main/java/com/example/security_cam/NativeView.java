package com.example.security_cam;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;
import java.util.Map;
import io.flutter.plugin.platform.PlatformView;

class NativeView implements PlatformView{
    private final TextView textView;
    TextView textInfo, textStatus, logCatcher;
    
    NativeView(Context context, int id, Map<String, Object> creationParams) {
        textView = new TextView(context);
        textView.setTextSize(42);
        textView.setBackgroundColor(Color.rgb(255, 255, 255));
        textView.setText("Rendered on a native Android view (id: " + id + ")");
    }

    @Override
    public View getView() {
        return textView;
    }

    @Override
    public void dispose() {}
}