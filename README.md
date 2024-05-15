To-Do List with Authentication using Flutter and Firebase

Overview:
This project is a simple To-Do List application built using Flutter and integrated with Firebase Authentication for user authentication. The application allows users to create, update, delete, and mark tasks as completed. It aims to provide a seamless and intuitive user experience for managing daily tasks.

Features:

User Authentication:
Users can sign up and log in securely using their email and password.
Firebase Authentication is used to handle user authentication, ensuring a safe and reliable login process.
To-Do List Management:
Users can view a list of tasks, add new tasks, edit existing tasks, and delete tasks.
Each task includes a title, description, and status (completed/incomplete).
Real-time Data Sync:
Firebase Firestore is used to store and manage task data.
The application synchronizes data in real-time, ensuring that any changes made by one user are instantly reflected across all devices.
Task Filtering and Sorting:
Users can search for specific tasks by entering keywords in the search bar.
Tasks can be sorted based on different criteria such as date, priority, or status.
User Profile:
Each user has a profile that displays basic information such as username and profile picture.
Users can update their profile information and change their profile picture.
Offline Support:
The application provides offline support, allowing users to view and interact with their tasks even when there is no internet connection.
Changes made while offline are synced with the Firebase server once the internet connection is restored.
Technologies Used:

Flutter: Flutter is a UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase. It is used to develop the cross-platform mobile application.

Firebase:

Firebase Authentication: Firebase Authentication provides backend services, easy-to-use SDKs, and ready-made UI libraries to authenticate users to your app.
Cloud Firestore: Cloud Firestore is a flexible, scalable database for mobile, web, and server development from Firebase and Google Cloud Platform. It is used to store and sync data between users and devices in real-time.
Installation:







Acknowledgments:
Special thanks to the Flutter and Firebase communities for their valuable resources and support.
