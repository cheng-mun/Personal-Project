package com.example.assignment2;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;

public class MyRecyclerAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    ArrayList<EventCategory> data = new ArrayList<>();
    ArrayList<Event> eventData = new ArrayList<>();

    ViewGroup parentView;
    private static final int VIEW_TYPE_CATEGORY = 1;
    private static final int VIEW_TYPE_EVENT = 2;

    public MyRecyclerAdapter(ViewGroup parent) {
        this.parentView = parent;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        int viewNum = getItemViewType();
        View v;
        RecyclerView.ViewHolder viewHolder = null;

        switch (viewNum) {
            case VIEW_TYPE_CATEGORY:
                v = LayoutInflater.from(parent.getContext()).inflate(R.layout.card_layout_evcat, parent, false);
                viewHolder = new CustomViewHolder(v);
                break;
            case VIEW_TYPE_EVENT:
                v = LayoutInflater.from(parent.getContext()).inflate(R.layout.card_layout_event, parent, false);
                viewHolder = new AnotherCustomViewHolder(v);
                break;
        }
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof CustomViewHolder) {
            CustomViewHolder categoryViewHolder = (CustomViewHolder) holder;
            categoryViewHolder.tvCatId.setText(data.get(position).getCategoryId());
            categoryViewHolder.tvCatName.setText(data.get(position).getCategoryName());
            categoryViewHolder.tvCatCount.setText(String.valueOf(data.get(position).getEventCount()));
            if (data.get(position).getActive()) {
                categoryViewHolder.tvCatActive.setText("Yes");
            } else {
                categoryViewHolder.tvCatActive.setText("No");
            }
            categoryViewHolder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Context context = categoryViewHolder.itemView.getContext();
                    Intent intent = new Intent(context, GoogleMapActivity.class);

                    String location = data.get(categoryViewHolder.getAdapterPosition()).getEventLocation();
                    intent.putExtra("location", location);

                    context.startActivity(intent);
                }
            });
        } else if (holder instanceof AnotherCustomViewHolder) {
            AnotherCustomViewHolder eventViewHolder = (AnotherCustomViewHolder) holder;
            eventViewHolder.tvEventId.setText("Id: " + eventData.get(position).getEventId());
            eventViewHolder.tvEventName.setText("Name: " + eventData.get(position).getEventName());
            eventViewHolder.tvEvCatId.setText("Category Id: " + eventData.get(position).getCategoryId());
            eventViewHolder.tvTickets.setText("Tickets: " + String.valueOf(eventData.get(position).getTicketAvailable()));
            if (eventData.get(position).getActive()) {
                eventViewHolder.tvEvActive.setText("Active");
            } else {
                eventViewHolder.tvEvActive.setText("Inactive");
            }
            eventViewHolder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Context context = eventViewHolder.itemView.getContext();
                    Intent intent = new Intent(context, EventGoogleResult.class);

                    String eventName = eventData.get(eventViewHolder.getAdapterPosition()).getEventName();
                    intent.putExtra("eventName", eventName);

                    context.startActivity(intent);
                }
            });
        }
    }

    @Override
    public int getItemCount() {
        int viewNum = getItemViewType();
        if (viewNum == VIEW_TYPE_CATEGORY) {
            if (this.data != null) {
                return this.data.size();
            }

        } else if (viewNum == VIEW_TYPE_EVENT) {
            if (this.eventData != null) {
                return this.eventData.size();
            }
        }
        return 0;
    }

    public int getItemViewType() {
        // Determine view type based on position
        if (parentView.getId() == R.id.fragment_container || parentView.getId() == R.id.frame_dashboard) {
            return VIEW_TYPE_CATEGORY;
        } else if (parentView.getId() == R.id.fragment_event) {
            return VIEW_TYPE_EVENT;
        }
        return 0;
    }

    public void setData(ArrayList<EventCategory> newData) {
        this.data = newData;
    }

    public void setDataEvent(ArrayList<Event> data) {
        this.eventData = data;
    }


    public class AnotherCustomViewHolder extends RecyclerView.ViewHolder {
        public TextView tvEventId;
        public TextView tvEventName;
        public TextView tvEvCatId;
        public TextView tvTickets;
        public TextView tvEvActive;

        public AnotherCustomViewHolder(View itemView) {
            super(itemView);
            tvEventId = itemView.findViewById(R.id.tv_idev);
            tvEventName = itemView.findViewById(R.id.tv_nameev);
            tvEvCatId = itemView.findViewById(R.id.tv_cate_id);
            tvTickets = itemView.findViewById(R.id.tv_tickets);
            tvEvActive = itemView.findViewById(R.id.tv_evactive);
        }
    }

    public class CustomViewHolder extends RecyclerView.ViewHolder {
        public TextView tvCatId;
        public TextView tvCatName;
        public TextView tvCatCount;
        public TextView tvCatActive;


        public CustomViewHolder(@NonNull View itemView) {
            super(itemView);
            tvCatId = itemView.findViewById(R.id.tv_idcat);
            tvCatName = itemView.findViewById(R.id.tv_namecat);
            tvCatCount = itemView.findViewById(R.id.tv_evcount);
            tvCatActive = itemView.findViewById(R.id.tv_activecat);
        }
    }
}
