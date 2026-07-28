package dev.echoes.kairos

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.PersistableBundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val PRIVACY_CHANNEL = "dev.echoes.kairos/privacy"
        private const val ASTRAEA_CHANNEL = "dev.echoes.kairos/astraea"
        private const val ASTRAEA_ACTION = "dev.echoes.astraea.action.LOCAL_SYNC"
        private const val ASTRAEA_PAYLOAD = "dev.echoes.astraea.extra.PAYLOAD"
        // Astraea kept its pre-rename application id on some installs. Try it
        // after the current id so an upgrade does not lose local delivery.
        private val ASTRAEA_PACKAGES = arrayOf(
            "dev.echoes.astraea",
            "dev.echoes.epochs",
            // Current Astraea development application id.
            "com.example.epochs",
        )
        private const val SENSITIVE_CLIPBOARD_FLAG = "android.content.extra.IS_SENSITIVE"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Prevent involuntary task-content exposure in Android's recents view
        // while still allowing deliberate screenshots inside the app.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            setRecentsScreenshotEnabled(false)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PRIVACY_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setSecure" -> {
                        if (call.arguments as? Boolean == true) {
                            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        } else {
                            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        }
                        result.success(null)
                    }
                    "copySensitive" -> {
                        val value = call.arguments as? String
                        if (value == null) result.error("invalid_argument", "Expected text", null)
                        else {
                            copySensitive(value)
                            result.success(null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ASTRAEA_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "sendToAstraea" -> {
                        val payload = call.arguments as? String
                        if (payload == null || payload.isBlank()) {
                            result.error("invalid_argument", "Expected a JSON payload", null)
                        } else {
                            try {
                                sendToAstraea(payload)
                                result.success(null)
                            } catch (error: Exception) {
                                result.error("astraea_unavailable", error.message, null)
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun copySensitive(value: String) {
        val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText("Kairos private key", value)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            clip.description.extras = PersistableBundle().apply {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    putBoolean(android.content.ClipDescription.EXTRA_IS_SENSITIVE, true)
                } else {
                    putBoolean(SENSITIVE_CLIPBOARD_FLAG, true)
                }
            }
        }
        clipboard.setPrimaryClip(clip)
        Handler(Looper.getMainLooper()).postDelayed({
            val current = clipboard.primaryClip?.getItemAt(0)?.coerceToText(this)?.toString()
            if (current == value) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) clipboard.clearPrimaryClip()
                else clipboard.setPrimaryClip(ClipData.newPlainText("", ""))
            }
        }, 60_000L)
    }

    /**
     * Sends a versioned, explicit app-to-app command. Keeping the package
     * explicit prevents another installed app from receiving task contents;
     * Astraea registers [ASTRAEA_ACTION] in its own exported entry activity.
     */
    private fun sendToAstraea(payload: String) {
        var lastError: Exception? = null
        for (packageName in ASTRAEA_PACKAGES) {
            val intent = Intent(ASTRAEA_ACTION).apply {
                setPackage(packageName)
                type = "application/json"
                putExtra(ASTRAEA_PAYLOAD, payload)
                addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            }
            try {
                startActivity(intent)
                return
            } catch (error: android.content.ActivityNotFoundException) {
                lastError = error
            }
        }
        throw lastError ?: android.content.ActivityNotFoundException(
            "Astraea is not installed"
        )
    }
}
