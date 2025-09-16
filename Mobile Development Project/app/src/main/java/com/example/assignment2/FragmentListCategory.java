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

import com.example.assignment2.provider.CategoryViewModel;

import java.util.ArrayList;
import java.util.List;

/**
 * A simple {@link Fragment} subclass.
 * Use the {@link FragmentListCategory#newInstance} factory method to
 * create an instance of this fragment.
 */
public class FragmentListCategory extends Fragment {
    private RecyclerView recyclerView;
    private MyRecyclerAdapter adapter;
    private ArrayList<EventCategory> categoryList;
    private CategoryViewModel categoryViewModel;

    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    public FragmentListCategory() {
    }

    public static FragmentListCategory newInstance(String param1, String param2) {
        FragmentListCategory fragment = new FragmentListCategory();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Initialize the category list
        categoryList = new ArrayList<>();
        // Get the ViewModel
        categoryViewModel = new ViewModelProvider(this).get(CategoryViewModel.class);
        // Observe the LiveData from the ViewModel
        categoryViewModel.getAllCategory().observe(this, new Observer<List<EventCategory>>() {
            @Override
            public void onChanged(List<EventCategory> eventCategories) {
                // Update the list and notify the adapter
                categoryList.clear();
                categoryList.addAll(eventCategories);
                adapter.notifyDataSetChanged();
            }
        });
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_list_category, container, false);

        // Find RecyclerView from the inflated layout
        recyclerView = view.findViewById(R.id.recyclerview);

        // Set up RecyclerView with a LinearLayoutManager
        LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
        recyclerView.setLayoutManager(layoutManager);

        // Initialize adapter with categoryList
        adapter = new MyRecyclerAdapter(container);
        adapter.setData(categoryList);
        recyclerView.setAdapter(adapter);

        return view;
    }
}