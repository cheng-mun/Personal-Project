package com.example.assignment2;

import androidx.fragment.app.FragmentActivity;

import android.location.Geocoder;
import android.os.Build;
import android.os.Bundle;
import android.widget.Toast;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.example.assignment2.databinding.ActivityGoogleMapBinding;

import java.util.Locale;

public class GoogleMapActivity extends FragmentActivity implements OnMapReadyCallback {

    private GoogleMap mMap;
    private ActivityGoogleMapBinding binding;
    private String location;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityGoogleMapBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        location = getIntent().getExtras().getString("location", "");

        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);
    }

    /**
     * Manipulates the map once available.
     * This callback is triggered when the map is ready to be used.
     * This is where we can add markers or lines, add listeners or move the camera. In this case,
     * we just add a marker near Sydney, Australia.
     * If Google Play services is not installed on the device, the user will be prompted to install
     * it inside the SupportMapFragment. This method will only be triggered once the user has
     * installed Google Play services and returned to the app.
     */
    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;
        String message = "API Check" + location;
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show();

        findCountryMoveCamera();
    }

    private void findCountryMoveCamera() {
        // initialise Geocode to search location using String
        Geocoder geocoder = new Geocoder(this, Locale.getDefault());

        if (location == null || location.isEmpty()) {
            runOnUiThread(() -> {
                String message = "Category address not found.";
                Toast.makeText(GoogleMapActivity.this, message, Toast.LENGTH_SHORT).show();
            });
            return;
        }

        // API 33 and above
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            /**
             * countryToFocus: String value, any string we want to search
             * maxResults: how many results to return if search was successful
             * successCallback method: if results are found, this method will be executed
             *                          runs in a background thread
             */
            geocoder.getFromLocationName(location, 1, addresses -> {
                // if there are results, this condition would return true
                if (!addresses.isEmpty()) {
                    // run on UI thread as the user interface will update once set map location
                    runOnUiThread(() -> {
                        // define new LatLng variable using the first address from list of addresses
                        LatLng newAddressLocation = new LatLng(
                                addresses.get(0).getLatitude(),
                                addresses.get(0).getLongitude()
                        );

                        // repositions the camera according to newAddressLocation
                        mMap.moveCamera(CameraUpdateFactory.newLatLng(newAddressLocation));

                        // just for reference add a new Marker
                        mMap.addMarker(
                                new MarkerOptions()
                                        .position(newAddressLocation)
                                        .title(location)
                        );

                        // set zoom level to 10f
                        mMap.animateCamera(CameraUpdateFactory.zoomTo(10f));
                    });
                } else {
                    runOnUiThread(() -> {
                        String message = "Category address not found.";
                        Toast.makeText(GoogleMapActivity.this, message, Toast.LENGTH_SHORT).show();
                    });
                }
            });
        }
    }
}