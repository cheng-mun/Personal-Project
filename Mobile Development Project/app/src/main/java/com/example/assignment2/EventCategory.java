package com.example.assignment2;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity(tableName = "category")
public class EventCategory {
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    private int id;
    @ColumnInfo()
    String categoryId;
    @ColumnInfo()
    String categoryName;
    @ColumnInfo()
    Integer eventCount;
    @ColumnInfo(name = "location")
    String eventLocation;
    @ColumnInfo()
    Boolean isActive;

    public EventCategory() {
        this.eventCount = 0;
        this.isActive = false;
    }

    public EventCategory(String categoryName, Integer eventCount, Boolean isActive) {
        this.categoryName = categoryName;
        this.eventCount = eventCount;
        this.isActive = isActive;
    }

    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(String categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public Integer getEventCount() {
        return eventCount;
    }

    public void setEventCount(Integer eventCount) {
        this.eventCount = eventCount;
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

    public String getEventLocation() {
        return eventLocation;
    }

    public void setEventLocation(String eventLocation) {
        this.eventLocation = eventLocation;
    }
}
