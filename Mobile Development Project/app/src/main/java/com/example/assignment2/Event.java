package com.example.assignment2;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity(tableName = "event")
public class Event {
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    private int id;
    @ColumnInfo()
    String eventId;
    @ColumnInfo()
    String categoryId;
    @ColumnInfo()
    String eventName;
    @ColumnInfo()
    Integer ticketAvailable;
    @ColumnInfo()
    Boolean isActive;

    public Event(String eventId, String categoryId, String eventName, Integer ticketAvailable, Boolean isActive) {
        this.eventId = eventId;
        this.categoryId = categoryId;
        this.eventName = eventName;
        this.ticketAvailable = ticketAvailable;
        this.isActive = isActive;
    }

    public Event() {
        this.ticketAvailable = 0;
        this.isActive = false;
    }

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(String categoryId) {
        this.categoryId = categoryId;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public Integer getTicketAvailable() {
        return ticketAvailable;
    }

    public void setTicketAvailable(Integer ticketAvailable) {
        this.ticketAvailable = ticketAvailable;
    }

    public Boolean getActive() {
        return isActive;
    }

    public void setActive(Boolean active) {
        isActive = active;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
