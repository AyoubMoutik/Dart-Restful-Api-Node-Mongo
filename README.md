# Course Management App

A full-stack application for managing online courses, built with Flutter for the frontend and Node.js with Express and MongoDB for the backend.

## Project Overview

This project is a comprehensive course management system that allows users to:

- View a list of available courses
- View detailed information about each course
- Add new courses
- Edit existing courses
- Delete courses

The application uses a modern architecture with a Flutter frontend that communicates with a RESTful API backend running on Node.js with Express, containerized with Docker on a separate Linux VM.

## Technology Stack

### Frontend

- **Flutter**: UI framework for building cross-platform applications
- **Bloc Pattern**: State management solution
- **HTTP**: API communication
- **Equatable**: Value equality

### Backend (Deployed on Linux VM)

- **Node.js**: JavaScript runtime for the server
- **Express**: Web framework for Node.js
- **MongoDB**: NoSQL database for data storage
- **Docker**: Containerization platform
- **Docker Compose**: Multi-container Docker applications

## Project Structure

```
restfulapi/
├── android/               # Android-specific configuration
├── assets/                # Static assets
│   └── images/
├── backend/              # Node.js backend code (Copy for reference only)
│   ├── src/
│   │   ├── controllers/   # API controllers
│   │   ├── models/        # Database models
│   │   ├── routes/        # API routes
│   │   └── server.js      # Main server file
│   ├── docker-compose.yml # Docker Compose configuration
│   ├── Dockerfile        # Docker configuration
│   └── package.json      # Node.js dependencies
├── ios/                  # iOS-specific configuration
├── lib/                  # Flutter application code
│   ├── course/
│   │   ├── bloc/         # Business Logic Components
│   │   ├── data_provider/ # API interactions
│   │   ├── models/       # Data models
│   │   ├── repository/   # Repository layer
│   │   └── screens/      # UI screens
│   ├── block_observer.dart
│   └── main.dart        # Entry point
├── pubspec.yaml         # Flutter dependencies
└── README.md           # This file
```

> **Note:** The `backend/` directory in this project contains a copy of the backend code for reference only. The actual backend is deployed on a separate Linux virtual machine.

## Backend Architecture

The backend follows a typical MVC (Model-View-Controller) architecture and runs on a Linux VM using Docker:

1. **Models**: Defines the MongoDB schema for courses
2. **Controllers**: Handles the business logic for CRUD operations
3. **Routes**: Defines the API endpoints
4. **Server**: Sets up the Express server and connects to MongoDB

### API Endpoints

| Method | Endpoint         | Description                |
| ------ | ---------------- | -------------------------- |
| GET    | /api/courses     | Retrieve all courses       |
| GET    | /api/courses/:id | Retrieve a specific course |
| POST   | /api/courses     | Create a new course        |
| PUT    | /api/courses/:id | Update an existing course  |
| DELETE | /api/courses/:id | Delete a course            |

## Frontend Architecture

The Flutter application uses the BLoC (Business Logic Component) pattern for state management:

1. **Data Provider**: Handles direct API calls
2. **Repository**: Acts as a mediator between the Data Provider and BLoC
3. **BLoC**: Manages app state and business logic
4. **UI**: Presents data to the user

## Docker Setup on Linux VM

The backend is containerized using Docker and deployed on a Linux VM, making it easy to deploy and run consistently.

### Docker Components

1. **Dockerfile**: Defines the Node.js application container
2. **docker-compose.yml**: Orchestrates multiple containers (API and MongoDB)

### Backend Container Setup

The `docker-compose.yml` file sets up two containers on the Linux VM:

1. **API Container**: Runs the Node.js Express application

   - Built from the local Dockerfile
   - Exposes port 5000
   - Depends on the MongoDB container

2. **MongoDB Container**: Runs MongoDB 4.4
   - Uses the official MongoDB image
   - Exposes port 27017
   - Uses a named volume for data persistence

### Network Configuration

The containers communicate through a bridge network named `app-network`, allowing the API to connect to MongoDB using the hostname `mongo`.

## VM Configuration

The backend is deployed on an Ubuntu virtual machine with IP address 192.168.56.101. This VM:

1. Has Docker and Docker Compose installed
2. Runs the backend containers
3. Exposes the API endpoint on port 5000
4. Has firewall rules allowing access to port 5000

## Getting Started

### Prerequisites

- Flutter SDK
- Linux VM with Docker and Docker Compose installed
- Node.js and npm (for development)

### Setting Up the Backend VM

1. SSH into the Ubuntu VM:

   ```bash
   ssh user@ip
   ```

2. Copy the backend code to the VM or clone it from a repository

   ```bash
   mkdir -p ~/course-api
   # Copy files or use git clone
   ```

3. Navigate to the backend directory and start the Docker containers:
   ```bash
   cd ~/course-api
   docker-compose up -d
   ```

This will start the API server on port 5000 and MongoDB on port 27017.

### Running the Flutter App

1. Make sure the backend is running on the VM
2. Ensure the API URL in `lib/course/data_provider/course_data.dart` points to your VM's IP address:
   ```dart
   static const String baseUrl = 'http://@ip:5000/api';
   ```
3. Run the Flutter app:
   ```bash
   flutter pub get
   flutter run
   ```

## MongoDB Connection Details

The backend uses MongoDB with connection retry logic to ensure robustness:

```javascript
// Connect to MongoDB with retry logic
const connectWithRetry = () => {
  mongoose
    .connect(process.env.MONGODB_URI)
    .then(() => {
      console.log("Connected to MongoDB");
    })
    .catch((err) => {
      console.error("MongoDB connection error:", err);
      console.log("Retrying in 5 seconds...");
      setTimeout(connectWithRetry, 5000);
    });
};

connectWithRetry();
```

This ensures that if the MongoDB container takes time to start up, the API will continue attempting to connect.

## Troubleshooting

### Common Issues and Solutions

1. **No internet connection error in Flutter app**:

   - Ensure the VM's IP address is correct in the Flutter app
   - Check that port 5000 is allowed through the VM's firewall
   - Verify that the backend containers are running with `docker ps`

2. **MongoDB connection errors**:

   - The VM might not have AVX instruction support, which is required for MongoDB 5.0+
   - Solution: Use MongoDB 4.4 in the docker-compose.yml file

3. **Android app connectivity issues**:
   - Ensure the internet permission is added to the Android manifest:
     ```xml
     <uses-permission android:name="android.permission.INTERNET" />
     ```

## Additional Notes

- The backend listens on all interfaces (`0.0.0.0`) to ensure it's accessible from outside the container.
- Course images are stored as URLs, not as files in the database.
- The MongoDB container uses version 4.4 to ensure compatibility with systems that don't support AVX instructions.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributors

- Ayoub Moutik
