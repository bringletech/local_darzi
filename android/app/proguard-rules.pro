##################################
## Flutter
##################################
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

##################################
## MainActivity & App Classes
##################################
-keep class com.mannytech.darzi.MainActivity { *; }
-keep class com.mannytech.darzi.** { *; }

##################################
## Firebase
##################################
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

##################################
## Gson
##################################
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken

##################################
## AndroidX
##################################
-keep class androidx.** { *; }
-dontwarn androidx.**

##################################
## Activities / Services / Receivers
##################################
-keep class * extends android.app.Activity
-keep class * extends android.app.Service
-keep class * extends android.content.BroadcastReceiver
-keep class * extends android.content.ContentProvider

##################################
## Prevent Flutter Generated Code Removal
##################################
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
