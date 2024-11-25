package com.example.mascotas_flutter

import android.content.Context
import android.os.Bundle
import android.view.View
import com.google.android.gms.maps.*
import com.google.android.gms.maps.model.*
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class MapAdapterView(
    context: Context,
    flutterEngine: FlutterEngine,
    id: Int,
    private val creationParams: Map<String, Any>?
) : PlatformView, MethodChannel.MethodCallHandler {

    private val methodChannel: MethodChannel
    private var googleMapOptions: GoogleMapOptions = GoogleMapOptions()
    private val mapView: MapView = MapView(context, googleMapOptions)
    private var googleMap: GoogleMap? = null
    private val markers = mutableMapOf<String, Marker>()
    private val polylines = mutableMapOf<String, Polyline>()
    private val polygons = mutableMapOf<String, Polygon>()
    private val streetView: StreetViewPanoramaView = StreetViewPanoramaView(context)
    private var streetViewPanorama: StreetViewPanorama? = null
    private var currentMode: String = "map"

    init {
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.map_adapter_$id"
        )
        methodChannel.setMethodCallHandler(this)

        mapView.onCreate(Bundle())
        streetView.onCreate(Bundle())

        initializeMap()
        initializeStreetView()
    }

    private fun initializeMap() {

        googleMapOptions.ambientEnabled(false)
        googleMapOptions.compassEnabled(true)

        googleMapOptions.zoomGesturesEnabled(true)
        googleMapOptions.scrollGesturesEnabled(false)
        googleMapOptions.tiltGesturesEnabled(false)
        googleMapOptions.rotateGesturesEnabled(true)


        mapView.getMapAsync { gMap ->
            googleMap = gMap

            val initialCameraPosition = creationParams?.get("initialCameraPosition") as? Map<*, *>
            val latitude = initialCameraPosition?.get("latitude") as? Double ?: 0.0
            val longitude = initialCameraPosition?.get("longitude") as? Double ?: 0.0
            val zoom = (initialCameraPosition?.get("zoom") as? Double)?.toFloat() ?: 12.0f

            val target = LatLng(latitude, longitude)
            googleMap?.moveCamera(CameraUpdateFactory.newLatLngZoom(target, zoom))

            googleMap?.setOnMapClickListener { latLng ->
                methodChannel.invokeMethod(
                    "onMapClick",
                    mapOf("latitude" to latLng.latitude, "longitude" to latLng.longitude)
                )
            }

            googleMap?.setOnMarkerClickListener { marker ->
                val customId = marker.tag as? String
                if (customId != null) {
                    methodChannel.invokeMethod("onMarkerClick", customId)
                }
                true
            }

            googleMap?.setOnCameraIdleListener {
                val position = googleMap?.cameraPosition
                methodChannel.invokeMethod("onCameraIdle", mapOf(
                    "latitude" to position?.target?.latitude,
                    "longitude" to position?.target?.longitude,
                    "zoom" to position?.zoom
                ))
            }
        }
    }

    private fun initializeStreetView() {
        streetView.getStreetViewPanoramaAsync { panorama ->
            streetViewPanorama = panorama
            streetViewPanorama?.setOnStreetViewPanoramaChangeListener { location ->
                methodChannel.invokeMethod("onStreetViewChange", mapOf(
                    "latitude" to location?.position?.latitude,
                    "longitude" to location?.position?.longitude
                ))
            }
        }
    }

    override fun getView(): View {
        return if (currentMode == "map") mapView else streetView
    }

    override fun dispose() {
        mapView.onDestroy()
        streetView.onDestroy()
        methodChannel.setMethodCallHandler(null)
    }

    // Lifecycle methods
    fun onResume() {
        mapView.onResume()
        streetView.onResume()
    }

    fun onPause() {
        mapView.onPause()
        streetView.onPause()
    }

    fun onLowMemory() {
        mapView.onLowMemory()
        streetView.onLowMemory()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "switchToMapView" -> {
                switchToMapView()
                result.success(null)
            }
            "switchToStreetView" -> {
                val latitude = call.argument<Double>("latitude") ?: 0.0
                val longitude = call.argument<Double>("longitude") ?: 0.0
                switchToStreetView(latitude, longitude)
                result.success(null)
            }
            "addMarker" -> {
                val id = call.argument<String>("id") ?: ""
                val latitude = call.argument<Double>("latitude") ?: 0.0
                val longitude = call.argument<Double>("longitude") ?: 0.0
                val title = call.argument<String>("title")
                addMarker(id, latitude, longitude, title)
                result.success(null)
            }
            "removeMarker" -> {
                val id = call.argument<String>("id") ?: ""
                removeMarker(id)
                result.success(null)
            }
            "updateMarker" -> {
                val id = call.argument<String>("id") ?: ""
                val latitude = call.argument<Double>("latitude")
                val longitude = call.argument<Double>("longitude")
                val title = call.argument<String>("title")
                updateMarker(id, latitude, longitude, title)
                result.success(null)
            }
            "moveCamera" -> {
                val latitude = call.argument<Double>("latitude") ?: 0.0
                val longitude = call.argument<Double>("longitude") ?: 0.0
                val zoom = call.argument<Double>("zoom")?.toFloat()
                moveCamera(latitude, longitude, zoom)
                result.success(null)
            }
            "animateCamera" -> {
                val latitude = call.argument<Double>("latitude") ?: 0.0
                val longitude = call.argument<Double>("longitude") ?: 0.0
                val zoom = call.argument<Double>("zoom")?.toFloat()
                animateCamera(latitude, longitude, zoom)
                result.success(null)
            }
            "setMapStyle" -> {
                val styleJson = call.argument<String>("styleJson") ?: ""
                setMapStyle(styleJson)
                result.success(null)
            }
            "setStreetViewRestrictions" -> {
                val pan = call.argument<Boolean>("pan") ?: true
                val nav =  call.argument<Boolean>("nav") ?: true
                val zoom = call.argument<Boolean>("zoom") ?: true
                setStreetViewRestrictions(pan, nav, zoom)
                result.success(null)
            }
            "setMapGesturesEnabled" -> {
                val zoom = call.argument<Boolean>("zoom") ?: true
                val scroll = call.argument<Boolean>("scroll") ?: true
                val tilt = call.argument<Boolean>("tilt") ?: true
                val rotate = call.argument<Boolean>("rotate") ?: true
                setMapGesturesEnabled(zoom, scroll, tilt, rotate)
                result.success(null)
            }
            "setUIControls" -> {
                val compassEnabled = call.argument<Boolean>("compassEnabled") ?: true
                val myLocationButtonEnabled = call.argument<Boolean>("myLocationButtonEnabled") ?: true
                setUIControls(compassEnabled, myLocationButtonEnabled)
                result.success(null)
            }
            "addPolyline" -> {
                val id = call.argument<String>("id") ?: ""
                val pointsData = call.argument<List<Map<String, Double>>>("points") ?: emptyList()
                val color = call.argument<Int>("color") ?: 0xFF0000FF.toInt()
                val points = pointsData.map { LatLng(it["latitude"]!!, it["longitude"]!!) }
                addPolyline(id, points, color)
                result.success(null)
            }
            "addPolygon" -> {
                val id = call.argument<String>("id") ?: ""
                val pointsData = call.argument<List<Map<String, Double>>>("points") ?: emptyList()
                val fillColor = call.argument<Int>("fillColor") ?: 0x550000FF
                val strokeColor = call.argument<Int>("strokeColor") ?: 0xFF0000FF.toInt()
                val points = pointsData.map { LatLng(it["latitude"]!!, it["longitude"]!!) }
                addPolygon(id, points, fillColor, strokeColor)
                result.success(null)
            }
            "removePolyline" -> {
                val id = call.argument<String>("id") ?: ""
                removePolyline(id)
                result.success(null)
            }
            "removePolygon" -> {
                val id = call.argument<String>("id") ?: ""
                removePolygon(id)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    // Map and Street View control methods
    fun switchToMapView() {
        currentMode = "map"
    }

    fun switchToStreetView(latitude: Double, longitude: Double) {
        currentMode = "street"
        streetViewPanorama?.setPosition(LatLng(latitude, longitude))
    }

    fun addMarker(id: String, latitude: Double, longitude: Double, title: String?) {
        val position = LatLng(latitude, longitude)
        val markerOptions = MarkerOptions().position(position).title(title)
        val marker = googleMap?.addMarker(markerOptions)
        marker?.tag = id
        if (marker != null) {
            markers[id] = marker
        }
    }

    fun removeMarker(id: String) {
        val marker = markers[id]
        marker?.remove()
        markers.remove(id)
    }

    fun updateMarker(id: String, latitude: Double?, longitude: Double?, title: String?) {
        val marker = markers[id]
        if (marker != null) {
            if (latitude != null && longitude != null) {
                marker.position = LatLng(latitude, longitude)
            }
            if (title != null) {
                marker.title = title
            }
        }
    }

    fun moveCamera(latitude: Double, longitude: Double, zoom: Float?) {
        val position = CameraPosition.Builder()
            .target(LatLng(latitude, longitude))
            .zoom(zoom ?: googleMap?.cameraPosition?.zoom ?: 12.0f)
            .build()
        googleMap?.moveCamera(CameraUpdateFactory.newCameraPosition(position))
    }

    fun animateCamera(latitude: Double, longitude: Double, zoom: Float?) {
        val position = CameraPosition.Builder()
            .target(LatLng(latitude, longitude))
            .zoom(zoom ?: googleMap?.cameraPosition?.zoom ?: 12.0f)
            .build()
        googleMap?.animateCamera(CameraUpdateFactory.newCameraPosition(position))
    }

    fun setMapStyle(styleJson: String) {
        googleMap?.setMapStyle(MapStyleOptions(styleJson))
    }

    fun setStreetViewRestrictions(pan: Boolean, nav: Boolean, zoom: Boolean) {
        streetViewPanorama?.setPanningGesturesEnabled(pan)
        streetViewPanorama?.setUserNavigationEnabled(nav)
        streetViewPanorama?.setZoomGesturesEnabled(zoom)
        // Tilt gestures are not available in StreetViewPanoramaUiSettings
    }

    fun setMapGesturesEnabled(zoom: Boolean, scroll: Boolean, tilt: Boolean, rotate: Boolean) {
        googleMap?.getUiSettings()?.setZoomGesturesEnabled(zoom)
        googleMap?.getUiSettings()?.setScrollGesturesEnabled(scroll)
        googleMap?.getUiSettings()?.setTiltGesturesEnabled(tilt)
        googleMap?.getUiSettings()?.setRotateGesturesEnabled(rotate)
    }

    fun setUIControls(compassEnabled: Boolean, myLocationButtonEnabled: Boolean) {
        googleMap?.getUiSettings()?.setCompassEnabled(compassEnabled)
        googleMap?.getUiSettings()?.setMyLocationButtonEnabled(myLocationButtonEnabled)
    }

    fun addPolyline(id: String, points: List<LatLng>, color: Int) {
        val polylineOptions = PolylineOptions()
            .addAll(points)
            .color(color)
        val polyline = googleMap?.addPolyline(polylineOptions)
        if (polyline != null) {
            polylines[id] = polyline
        }
    }

    fun addPolygon(id: String, points: List<LatLng>, fillColor: Int, strokeColor: Int) {
        val polygonOptions = PolygonOptions()
            .addAll(points)
            .fillColor(fillColor)
            .strokeColor(strokeColor)
        val polygon = googleMap?.addPolygon(polygonOptions)
        if (polygon != null) {
            polygons[id] = polygon
        }
    }

    fun removePolyline(id: String) {
        polylines[id]?.remove()
        polylines.remove(id)
    }

    fun removePolygon(id: String) {
        polygons[id]?.remove()
        polygons.remove(id)
    }
}
