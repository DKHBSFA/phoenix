# Flutter-specific ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep BitNet native bindings
-keep class com.phoenix.phoenix_app.** { *; }

# Dart FFI — keep native method names
-keepclassmembers class * {
    native <methods>;
}

# Play Core (deferred components) — not used but referenced by Flutter engine
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
