package net.afrix.e_comerece

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    internal var channel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val intent = intent
        runInt(intent)
    }

    private fun runInt(intent: Intent) {
        if (channel == null) {
            channel = MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, "app.channel.shared.data")

            channel!!.setMethodCallHandler { call, result ->
                if (call.method == "toast") {
                    toast(call.arguments.toString())
                    result.success("done successfully")
                }
            }
        }

    }

    internal fun toast(string: String) {
        Toast.makeText(this, string, Toast.LENGTH_LONG).show()
    }
}
