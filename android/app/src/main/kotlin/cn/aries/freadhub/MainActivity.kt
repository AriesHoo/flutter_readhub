package cn.aries.freadhub

import android.os.Bundle
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    window.setBackgroundDrawable(ColorDrawable(Color.WHITE))
  }
}
