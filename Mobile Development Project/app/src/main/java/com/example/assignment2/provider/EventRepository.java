package com.example.assignment2.provider;

import android.app.Application;

import androidx.lifecycle.LiveData;

import com.example.assignment2.Event;

import java.util.List;

public class EventRepository {

    // private class variable to hold reference to DAO
    private EventDAO eventDAO;
    // private class variable to temporary hold all the items retrieved and pass outside of this class
    private LiveData<List<Event>> eventLiveData;

    // constructor to initialise the repository class
    EventRepository(Application application) {
        // get reference/instance of the database
        SpecialDatabase db = SpecialDatabase.getDatabase(application);

        // get reference to DAO, to perform CRUD operations
        eventDAO = db.eventDAO();

        // once the class is initialised get all the items in the form of LiveData
        eventLiveData = eventDAO.getAllItems();
    }

    /**
     * Repository method to get all cards
     *
     * @return LiveData of type List<Item>
     */
    LiveData<List<Event>> getAllEvent() {
        return eventLiveData;
    }

    /**
     * Repository method to insert one single item
     *
     * @param event object containing details of new Item to be inserted
     */
    void insert(Event event) {
        SpecialDatabase.databaseWriteExecutor.execute(() -> eventDAO.addItem(event));
    }

    public void delete(Event event) {
        SpecialDatabase.databaseWriteExecutor.execute(() -> eventDAO.delete(event));
    }

    void deleteAll() {
        SpecialDatabase.databaseWriteExecutor.execute(() -> eventDAO.deleteAll());
    }
}
