package com.example.assignment2.provider;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

import com.example.assignment2.Event;
import com.example.assignment2.EventCategory;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Database(entities = {Event.class, EventCategory.class}, version = 2)
public abstract class SpecialDatabase extends RoomDatabase {

    public static final String SPECIAL_DATABASE = "special_database";

    public abstract CategoryDAO categoryDAO();

    public abstract EventDAO eventDAO();

    // marking the instance as volatile to ensure atomic access to the variable
    private static volatile SpecialDatabase INSTANCE;
    private static final int NUMBER_OF_THREADS = 4;
    public static final ExecutorService databaseWriteExecutor =
            Executors.newFixedThreadPool(NUMBER_OF_THREADS);

    /**
     * Since this class is an abstract class, to get the database reference we would need
     * to implement a way to get reference to the database.
     *
     * @param context Application of Activity Context
     * @return a reference to the database for read and write operation
     */
    public static SpecialDatabase getDatabase(final Context context) {
        if (INSTANCE == null) {
            synchronized (SpecialDatabase.class) {
                if (INSTANCE == null) {
                    INSTANCE = Room.databaseBuilder(context.getApplicationContext(),
                                    SpecialDatabase.class, "special_database")
                            .fallbackToDestructiveMigration() // Allow destructive migrations
                            .build();
                }
            }
        }
        return INSTANCE;
    }
}
