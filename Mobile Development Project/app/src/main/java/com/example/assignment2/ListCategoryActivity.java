package com.example.assignment2;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.appcompat.widget.Toolbar;

import android.os.Bundle;

public class ListCategoryActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_list_category);
        // Get the FragmentManager
        FragmentManager fragmentManager = getSupportFragmentManager();

        // Begin a FragmentTransaction
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();

        // Replace the contents of the fragment_container with the new fragment
        FragmentListCategory fragment = new FragmentListCategory(); // Replace with your fragment class
        fragmentTransaction.replace(R.id.fragment_container, fragment);

        // Commit the transaction
        fragmentTransaction.commit();
        Toolbar toolbar = findViewById(R.id.toolbar_catlist);
        setSupportActionBar(toolbar);

        // Enable the back button on the toolbar
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowHomeEnabled(true);
        getSupportActionBar().setTitle("All Categories");
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed(); // Navigate back when the back button on the toolbar is clicked
        return true;
    }
}