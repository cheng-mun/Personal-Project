package com.example.assignment2;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import android.os.Bundle;

public class ListEventActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_list_event);

        // Get the FragmentManager
        FragmentManager fragmentManager = getSupportFragmentManager();

        // Begin a FragmentTransaction
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();

        // Replace the contents of the fragment_container with the new fragment
        FragmentListEvent fragment = new FragmentListEvent(); // Replace with your fragment class
        fragmentTransaction.replace(R.id.fragment_event, fragment);

        // Commit the transaction
        fragmentTransaction.commit();

        Toolbar toolbar = findViewById(R.id.toolbar_evlist);
        setSupportActionBar(toolbar);

        // Enable the back button on the toolbar
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowHomeEnabled(true);
        getSupportActionBar().setTitle("Events Page");
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed(); // Navigate back when the back button on the toolbar is clicked
        return true;
    }
}