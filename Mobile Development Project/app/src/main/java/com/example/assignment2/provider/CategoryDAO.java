package com.example.assignment2.provider;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

import com.example.assignment2.EventCategory;

import java.util.List;

@Dao
public interface CategoryDAO {

    @Query("select * from category")
    LiveData<List<EventCategory>> getAllItems();

    @Insert
    void addItem(EventCategory eventCategory);

    @Query("DELETE FROM category")
    void deleteAll();
    @Update
    void update(EventCategory eventCategory);
}

