package com.example.assignment2.provider;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import com.example.assignment2.Event;

import java.util.List;

@Dao
public interface EventDAO {

    @Query("select * from event")
    LiveData<List<Event>> getAllItems();

    @Insert
    void addItem(Event event);

    @Delete
    void delete(Event event);

    @Query("DELETE FROM event")
    void deleteAll();
}
