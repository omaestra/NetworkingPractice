# ``NetworkingPractice``

Exploring networking layer implementation of paginated data.

## Overview

The challenge is to load all the paginated data before taking some action with the data (e.g. filtering, sorting, etc.). Since the API does not provide server-side filtering nor sorting capabilities, we need to load all the paginated data before we are able to filter or sort the data.
Also, for demostration purposes I am loading the page to get only the IDs of the objects, and then perform another HTTP request to the API to get the details of that particular item.

For this reason, I have implemented a concurrent way of loading all the pages along with their details and storing them on a local list. 

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
