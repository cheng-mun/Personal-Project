package com.example.assignment2;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class LoginPage extends AppCompatActivity {
    EditText loginUser;
    EditText loginPassword;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login_page);
        //on create of login activity, create share preference object to access android's persistent storage
        SharedPreferences sharedPreferences = getSharedPreferences("UNIQUE_FILE_NAME", MODE_PRIVATE);
        //save key-value pairs into the preference file
        String userRestored = sharedPreferences.getString("KEY_USERNAME", "USER");
        //connect with the UI element to be used
        loginUser = findViewById(R.id.editTextText4);
        //set it as the string store in shared preference
        loginUser.setText(userRestored);
    }

    public void buttonLogin(View view) {
        //reference to UI elements
        loginUser = findViewById(R.id.editTextText4);
        loginPassword = findViewById(R.id.editTextTextPassword3);
        String username = loginUser.getText().toString();
        String password = loginPassword.getText().toString();

        //create object to access android's persistent storage
        SharedPreferences sharedPreferences = getSharedPreferences("UNIQUE_FILE_NAME", MODE_PRIVATE);
        String userRestored = sharedPreferences.getString("KEY_USERNAME", "USER");
        String passwordRestored = sharedPreferences.getString("KEY_PASSWORD", "PASSWORD");

        //validate user input, check if required field is leave blank, show invalid toast
        if (username.isEmpty() || password.isEmpty()) {
            Toast.makeText(this, "Required Field is empty", Toast.LENGTH_SHORT).show();
            return;
        }
        //if user input is same as the ones saved in shared preference, proceed to dashboard
        if (username.equals(userRestored) && password.equals(passwordRestored)) {
            Toast.makeText(this, "Login Successful", Toast.LENGTH_SHORT).show();
            Intent intent = new Intent(this, Dashboard.class);
            startActivity(intent);
        }
        //handle other case, such as unregistered user
        else {
            Toast.makeText(this, "Username or Password incorrect", Toast.LENGTH_SHORT).show();
        }
    }

    //method for register button, for user who would like to re-register
    public void buttonRegister(View view) {
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);
    }
}