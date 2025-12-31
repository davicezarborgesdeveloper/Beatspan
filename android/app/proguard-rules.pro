# Beatspan - ProGuard Rules
# Este arquivo contém regras de ofuscação e otimização para builds de release

# Mantém informações de linha para stack traces
-keepattributes SourceFile,LineNumberTable

# Mantém anotações
-keepattributes *Annotation*

# Mantém classes nativas
-keepclasseswithmembernames class * {
    native <methods>;
}

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Spotify SDK
-keep class com.spotify.** { *; }
-keep class com.spotify.sdk.android.** { *; }
-dontwarn com.spotify.**

# Gson (se usado)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Mantém enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Previne otimização excessiva que pode quebrar reflection
-keepattributes InnerClasses
-keep class **.R
-keep class **.R$* {
    <fields>;
}
