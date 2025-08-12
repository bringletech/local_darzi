##################################
## Flutter
##################################
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

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
## App Models
##################################
-keep class com.mannytech.darzi.models.** { *; }

##################################
## AndroidX
##################################
-keep class androidx.** { *; }
-dontwarn androidx.**
