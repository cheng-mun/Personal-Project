package com.example.assignment2;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {
    //declare variables to be used in the methodsCM
    EditText editText;
    EditText editTextPassword;
    EditText editTextPassword2;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    // method for register button, view object of view Class so that method appears for onClick
    public void buttonRegister(View view) {
        //get reference to the UI elements by looking at the id and search in current Activity
        editText = findViewById(R.id.editTextText);
        editTextPassword = findViewById(R.id.editTextTextPassword);
        editTextPassword2 = findViewById(R.id.editTextTextPassword2);

        //convert into Strings
        String username = editText.getText().toString();
        String password = editTextPassword.getText().toString();
        String passwordConfirm = editTextPassword2.getText().toString();

        //validate user input
        //if either text box is left empty, show an invalid toast
        if (username.isEmpty() || password.isEmpty() || passwordConfirm.isEmpty()) {
            Toast.makeText(this, "Required Field is empty", Toast.LENGTH_SHORT).show();
            return;
        }
        //if all field are filled in and both password and confirmation is the same, save the
        //username and password into shared preference then open the login page
        if (password.equals(passwordConfirm)) {
            Toast.makeText(this, "Registration Successful", Toast.LENGTH_SHORT).show();
            //method called to save to persistent storage
            saveDataToSharedPreference(username, password);
            Intent intent = new Intent(this, LoginPage.class);
            startActivity(intent);
            //to handle other cases, such as password being unequal
        } else {
            Toast.makeText(this, "Registration Failed", Toast.LENGTH_SHORT).show();
        }
    }

    //method for Login button, opens the login page for users that have registered
    public void buttonLogin(View view) {
        Intent intent = new Intent(this, LoginPage.class);
        startActivity(intent);
    }

    //shared preference method
    private void saveDataToSharedPreference(String username, String password) {
        //create object of shared preference class to access Android's persistent storage
        SharedPreferences sharedPreferences = getSharedPreferences("UNIQUE_FILE_NAME", MODE_PRIVATE);

        //.edit function to access the file using Editor variable
        SharedPreferences.Editor editor = sharedPreferences.edit();

        //save key-value pairs to shared preference file
        editor.putString("KEY_USERNAME", username);
        editor.putString("KEY_PASSWORD", password);

        //save data in the background
        editor.apply();
    }
}