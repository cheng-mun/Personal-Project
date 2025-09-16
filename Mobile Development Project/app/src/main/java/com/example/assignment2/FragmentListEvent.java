package com.example.assignment2;

import android.os.Bundle;

import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.example.assignment2.provider.EventViewModel;

import java.util.ArrayList;
import java.util.List;

/**
 * A simple {@link Fragment} subclass.
 * Use the {@link FragmentListEvent#newInstance} factory method to
 * create an instance of this fragment.
 */
public class FragmentListEvent extends Fragment {
    private RecyclerView recyclerView;
    private MyRecyclerAdapter adapter;
    private ArrayList<Event> eventList;
    private EventViewModel eventViewModel;

    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    public FragmentListEvent() {
        // Required empty public constructor
    }

    public static FragmentListEvent newInstance(String param1, String param2) {
        FragmentListEvent fragment = new FragmentListEvent();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        eventList = new ArrayList<>();
        eventViewModel = new ViewModelProvider(this).get(EventViewModel.class);
        eventViewModel.getAllEvent().observe(this, new Observer<List<Event>>() {
            @Override
            public void onChanged(List<Event> event) {
                // Update the list and notify the adapter
                eventList.clear();
                eventList.addAll(event);
                adapter.notifyDataSetChanged();
            }
        });

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_list_event, container, false);

        // Find RecyclerView from the inflated layout
        recyclerView = view.findViewById(R.id.recycler_event);

        // Set up RecyclerView with a LinearLayoutManager
        LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
        recyclerView.setLayoutManager(layoutManager);

        // Initialize adapter with eventList
        adapter = new MyRecyclerAdapter(container);
        adapter.setDataEvent(eventList);
        recyclerView.setAdapter(adapter);

        return view;
    }
}