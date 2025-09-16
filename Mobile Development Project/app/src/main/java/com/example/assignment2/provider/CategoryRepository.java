package com.example.assignment2.provider;

import android.app.Application;

import androidx.lifecycle.LiveData;

import com.example.assignment2.EventCategory;

import java.util.List;

public class CategoryRepository {

    // private class variable to hold reference to DAO
    private CategoryDAO categoryDAO;
    // private class variable to temporary hold all the items retrieved and pass outside of this class
    private LiveData<List<EventCategory>> categoryLiveData;

    // constructor to initialise the repository class
    CategoryRepository(Application application) {
        // get reference/instance of the database
        SpecialDatabase db = SpecialDatabase.getDatabase(application);

        // get reference to DAO, to perform CRUD operations
        categoryDAO = db.categoryDAO();

        // once the class is initialised get all the items in the form of LiveData
        categoryLiveData = categoryDAO.getAllItems();
    }

    /**
     * Repository method to get all cards
     *
     * @return LiveData of type List<Item>
     */
    LiveData<List<EventCategory>> getAllCategory() {
        return categoryLiveData;
    }

    /**
     * Repository method to insert one single item
     *
     * @param category object containing details of new Item to be inserted
     */
    void insert(EventCategory category) {
        SpecialDatabase.databaseWriteExecutor.execute(() -> categoryDAO.addItem(category));
    }

    void deleteAll() {
        SpecialDatabase.databaseWriteExecutor.execute(() -> categoryDAO.deleteAll());
    }

    void update(EventCategory eventCategory) {
        SpecialDatabase.databaseWriteExecutor.execute(() -> categoryDAO.update(eventCategory));
    }
}

