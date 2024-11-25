package com.example.mascotas_flutter

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import android.widget.Toast


class MapActivity : AppCompatActivity(), OnMapReadyCallback {
    private lateinit var googleMap: GoogleMap
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    private var markers: ArrayList<Map<String, Any>> = ArrayList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_map)

        // Get data from intent
        latitude = intent.getDoubleExtra("latitude", 0.0)
        longitude = intent.getDoubleExtra("longitude", 0.0)
        markers = intent.getSerializableExtra("markers") as ArrayList<Map<String, Any>>

        // Initialize map
        val mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)
    }

    override fun onMapReady(map: GoogleMap) {
        googleMap = map

        // Move camera to the initial position
        val position = LatLng(latitude, longitude)
        googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(position, 16.0f))

        // Add markers
        for (marker in markers) {
            val markerPosition = LatLng(marker["latitude"] as Double, marker["longitude"] as Double)
            val title = marker["title"] as String
            googleMap.addMarker(MarkerOptions()
                .position(markerPosition)
                .title(title)
                .snippet("This is the initial marker."))
        }


        googleMap.setOnMarkerClickListener { marker ->
            // Handle marker click event
            Toast.makeText(this,  "Clicked marker: ${marker.title}", Toast.LENGTH_SHORT).show()

            // Return false to allow default behavior (e.g., showing title)
            false
        }
    }
}
