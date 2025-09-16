package com.example.assignment2;

import androidx.annotation.NonNull;
import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.view.GestureDetectorCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProvider;

import android.content.Intent;
import android.os.Bundle;
import android.view.GestureDetector;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.example.assignment2.provider.CategoryViewModel;
import com.example.assignment2.provider.EventViewModel;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.navigation.NavigationView;
import com.google.android.material.snackbar.Snackbar;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;


public class Dashboard extends AppCompatActivity {
    TextView evId;
    TextView evName;
    TextView catId;
    TextView tickets;
    Switch isActive;
    ArrayList<EventCategory> checkList;
    CategoryViewModel categoryViewModel;
    EventViewModel eventViewModel;
    private GestureDetectorCompat mDetector;
    FloatingActionButton fab;
    EventCategory categoryUndo;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.coordinator_layout);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        DrawerLayout drawerLayout = findViewById(R.id.drawer_layout);
        fab = findViewById(R.id.fab);
        setSupportActionBar(toolbar);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(this, drawerLayout, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawerLayout.addDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(new MyNavigationListener());

        FragmentManager fragmentManager = getSupportFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        FragmentListCategory fragment = new FragmentListCategory();
        fragmentTransaction.replace(R.id.frame_dashboard, fragment);
        fragmentTransaction.commit();
        categoryViewModel = new ViewModelProvider(this).get(CategoryViewModel.class);
        eventViewModel = new ViewModelProvider(this).get(EventViewModel.class);

        CustomGestureDetector customGestureDetector = new CustomGestureDetector();
        mDetector = new GestureDetectorCompat(this, customGestureDetector);
        mDetector.setOnDoubleTapListener(customGestureDetector);

        View touchpad = findViewById(R.id.view);
        touchpad.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                mDetector.onTouchEvent(event);
                return true;
            }
        });

        evId = findViewById(R.id.editTextText5);
        evName = findViewById(R.id.editTextText6);
        catId = findViewById(R.id.editTextText7);
        tickets = findViewById(R.id.editTextNumber2);
        isActive = findViewById(R.id.switch2);
        checkList = new ArrayList<>();

        categoryViewModel.getAllCategory().observe(this, new Observer<List<EventCategory>>() {
            @Override
            public void onChanged(List<EventCategory> eventCategories) {
                checkList.clear();
                checkList.addAll(eventCategories);
            }
        });

        //floating action button on click
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                saveEvent();
            }
        });
    }

    public void clearField() {
        evId.setText("");
        evName.setText("");
        catId.setText("");
        tickets.setText("");
        isActive.setChecked(false);
    }

    private void saveEvent() {
        Random r = new Random();
        char firstChar = 'E';
        char random1 = (char) (r.nextInt(26) + 'A');
        char random2 = (char) (r.nextInt(26) + 'A');
        int randomNum = r.nextInt(100000);
        String eventId = String.format("%c%c%c-%05d", firstChar, random1, random2, randomNum);

        String eventName = evName.getText().toString();
        String categoryId = catId.getText().toString();
        String stringTicket = tickets.getText().toString();
        boolean boolSwitch = isActive.isChecked();

        if (eventName.isEmpty() || categoryId.isEmpty()) {
            Toast.makeText(Dashboard.this, "Required field is empty", Toast.LENGTH_SHORT).show();
            return;
        }
        if (!eventName.matches(".*[a-zA-Z].*") || eventName.matches(".*[^a-zA-Z0-9].*")) {
            Toast.makeText(Dashboard.this, "Invalid event name", Toast.LENGTH_SHORT).show();
            return;
        }

        boolean idExist = false;
        for (EventCategory eventCategory : checkList) {
            if (eventCategory.getCategoryId().equals(categoryId)) {
                categoryUndo = eventCategory;
                idExist = true;
                eventCategory.setEventCount(eventCategory.getEventCount() + 1);
                categoryViewModel.update(eventCategory);
            }
        }

        if (!idExist) {
            Toast.makeText(Dashboard.this, "Category does not exist", Toast.LENGTH_SHORT).show();
            return;
        }
        Event event = new Event();
        event.setEventName(eventName);
        event.setCategoryId(categoryId);
        event.setActive(boolSwitch);

        if (!stringTicket.isEmpty()) {
            int intTicket = Integer.parseInt(stringTicket);
            event.setTicketAvailable(intTicket);
        }

        evId.setText(eventId);
        event.setEventId(eventId);
        eventViewModel.insert(event);

        String message = "Event saved: " + eventId + " to " + categoryId;
        Snackbar.make(fab, message, Snackbar.LENGTH_LONG)
                .setAction("UNDO", new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        eventViewModel.delete(event);
                        categoryUndo.setEventCount(categoryUndo.getEventCount() - 1);
                        categoryViewModel.update(categoryUndo);
                        clearField();
                    }
                })
                .show();
    }

    class MyNavigationListener implements NavigationView.OnNavigationItemSelectedListener {
        DrawerLayout drawerLayout = findViewById(R.id.drawer_layout);

        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            // get the id of the selected item
            int id = item.getItemId();

            if (id == R.id.option_viewcat) {
                startActivity(new Intent(Dashboard.this, ListCategoryActivity.class));

            } else if (id == R.id.option_addcat) {
                startActivity(new Intent(Dashboard.this, NewEventCategory.class));

            } else if (id == R.id.option_viewev) {
                startActivity(new Intent(Dashboard.this, ListEventActivity.class));

            } else if (id == R.id.option_logout) {
                startActivity(new Intent(Dashboard.this, LoginPage.class));
                finish();
            }
            drawerLayout.closeDrawers();
            return true;
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.options_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.option_refresh) {

        } else if (id == R.id.option_clear_event) {
            evId.setText("");
            clearField();

        } else if (id == R.id.option_del_allcat) {
            categoryViewModel.deleteAll();

        } else if (id == R.id.option_del_allev) {
            eventViewModel.deleteAll();
        }
        return true;
    }

    class CustomGestureDetector extends GestureDetector.SimpleOnGestureListener {

        @Override
        public void onLongPress(@NonNull MotionEvent e) {
            evId.setText("");
            evName.setText("");
            catId.setText("");
            tickets.setText("");
            isActive.setChecked(false);
            super.onLongPress(e);
        }

        @Override
        public boolean onDoubleTap(@NonNull MotionEvent e) {
            saveEvent();
            return super.onDoubleTap(e);
        }
    }
}