package com.example.assignment2;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class EventGoogleResult extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_event_google_result);
        // using the ID set in previous step, get reference to the WebView
        WebView webView = findViewById(R.id.webview);

// get event name from Intent
        String eventName = getIntent().getExtras().getString("eventName");


// compile the google search URL, which will be used to load into WebView
        String googleURL = "https://www.google.com/search?q=" + eventName;

// set new WebView Client for the WebView
// This gives the WebView ability to be load the URL in the current WebView
// instead of navigating to default web browser of the device
        webView.setWebViewClient(new WebViewClient());
        webView.loadUrl(googleURL);
    }
}