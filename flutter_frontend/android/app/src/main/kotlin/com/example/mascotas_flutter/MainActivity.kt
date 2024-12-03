package com.example.mascotas_flutter

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class MainActivity : FlutterActivity() {

    private val VIEW_TYPE_ID = "com.example.map_adapter"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val mapViewFactory = MapAdapterViewFactory(flutterEngine)

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(VIEW_TYPE_ID, mapViewFactory)
    }
}

class MapAdapterViewFactory(private val flutterEngine: FlutterEngine) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        val creationParams = args as? Map<String, Any>
        return MapAdapterView(context, flutterEngine, id, creationParams)
    }
}
