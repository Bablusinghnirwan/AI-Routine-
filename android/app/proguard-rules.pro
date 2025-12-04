# Flutter Wrapper - Keep all Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.embedding.engine.FlutterJNI { *; }
-dontwarn io.flutter.embedding.**

# Hive - Keep all Hive related classes and adapters
-keep class hive.** { *; }
-keep class io.flutter.plugins.hive.** { *; }
-keepclassmembers class * extends hive.HiveObject {
    <fields>;
}
-keep @interface hive.HiveType
-keep @interface hive.HiveField
-keepclasseswithmembers class * {
    @hive.HiveType *;
}
-keepclasseswithmembers class * {
    @hive.HiveField *;
}

# Keep all generated Hive adapters
-keep class **$HiveAdapter { *; }
-keep class * implements hive.TypeAdapter { *; }

# Supabase - Keep all Supabase classes
-keep class io.supabase.** { *; }
-keep class com.supabase.** { *; }
-dontwarn io.supabase.**
-dontwarn com.supabase.**

# Supabase Realtime
-keep class io.supabase.realtime.** { *; }
-keep class io.supabase.storage.** { *; }
-keep class io.supabase.auth.** { *; }
-keep class io.supabase.postgrest.** { *; }

# Provider - Keep all Provider classes
-keep class provider.** { *; }
-keep class androidx.lifecycle.** { *; }

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Path Provider
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep all app models and controllers - CRITICAL
-keep class com.dailyroutine.** { *; }
-keepclassmembers class com.dailyroutine.** { *; }

# Keep all Dart generated code
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Gson (if used by any dependency)
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.** { *; }
-keep class com.google.gson.stream.** { *; }
-keep class * extends com.google.gson.TypeAdapter

# Google Play Core
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# OkHttp and Retrofit (used by Supabase)
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keep class okio.** { *; }

# Serialization
-keepattributes *Annotation*, InnerClasses
-dontnote kotlinx.serialization.AnnotationsKt
-keepclassmembers class kotlinx.serialization.json.** {
    *** Companion;
}
-keepclasseswithmembers class kotlinx.serialization.json.** {
    kotlinx.serialization.KSerializer serializer(...);
}

# Keep all model classes with their fields
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# General rules
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
-repackageclasses ''
-allowaccessmodification
-optimizations !code/simplification/arithmetic
-keepattributes *Annotation*

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep setters in Views
-keepclassmembers public class * extends android.view.View {
   void set*(***);
   *** get*();
}

# Keep Activity subclasses
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

# Parcelable
-keepclassmembers class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator CREATOR;
}

# Enum
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
