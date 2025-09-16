package com.example.assignment2;


import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.ViewModelProvider;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.Switch;
import android.widget.Toast;

import com.example.assignment2.provider.CategoryViewModel;

import java.util.ArrayList;
import java.util.Random;

public class NewEventCategory extends AppCompatActivity {
    EditText categoryId;
    EditText categoryName;
    EditText eventCount;
    EditText eventLocation;
    Switch isActive;
    ArrayList<EventCategory> listEvCat;
    CategoryViewModel categoryViewModel;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_event_category);
        categoryId = findViewById(R.id.editTextText2);
        categoryName = findViewById(R.id.editTextText3);
        eventCount = findViewById(R.id.editTextNumber);
        eventLocation = findViewById(R.id.editTextText8);
        isActive = findViewById(R.id.switch1);
        listEvCat = new ArrayList<>();
        categoryViewModel = new ViewModelProvider(this).get(CategoryViewModel.class);
    }

    public void buttonNewCategory(View view) {
        //generating random category id with a specific format
        //create random class object to access its methods
        Random r = new Random();
        char firstChar = 'C';
        //'A' stands for the ASCII value 65, generate random number 0-25 + 65 then cast to char
        char random1 = (char) (r.nextInt(26) + 'A');
        char random2 = (char) (r.nextInt(26) + 'A');
        int randomNum = r.nextInt(10000);
        String generatedId = String.format("%c%c%c-%04d", firstChar, random1, random2, randomNum);


        //convert to strings and boolean
        String stringName = categoryName.getText().toString();
        String stringCount = eventCount.getText().toString();
        String stringLocation = eventLocation.getText().toString();
        boolean boolActive = isActive.isChecked();

        if (!stringName.matches(".*[a-zA-Z].*") || stringName.matches(".*[^a-zA-Z0-9].*")) {
            Toast.makeText(this, "Invalid event name", Toast.LENGTH_SHORT).show();
            return;
        }

        EventCategory eventCategory = new EventCategory();
        eventCategory.setCategoryName(stringName);
        eventCategory.setEventLocation(stringLocation);
        eventCategory.setActive(boolActive);

        //if the event count is left empty, save info to save preference in a default value 0
        if (!stringCount.isEmpty()) {
            int intCount = Integer.parseInt(stringCount);
            eventCategory.setEventCount(intCount);
        }
        //if input is valid, set the generated id to its field and show successful toast
        categoryId.setText(generatedId);
        eventCategory.setCategoryId(generatedId);
        listEvCat.add(eventCategory);
        categoryViewModel.insert(eventCategory);

        String message = "Category saved successfully: " + generatedId;
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
        startActivity(new Intent(this, Dashboard.class));
    }

}