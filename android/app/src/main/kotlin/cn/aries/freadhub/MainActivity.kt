package cn.aries.freadhub

import android.os.Bundle
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    window.setBackgroundDrawable(ColorDrawable(Color.WHITE))
  }
}
