# ParPals

ParPals is a social golfing app designed for local golf courses in Wilmington, NC. The app allows users to create a golf profile with their handicap, play local courses with friends through a party system, and save their previous rounds for future reference.

## Features

- **Create a Golf Profile**: Track your golfing stats, including your handicap.
- **Join/Host Parties**: Play with friends or new people through the party system.
- **Save Previous Rounds**: Log and review your past rounds with ease.
- **Map of Local Courses**: View and navigate local golf courses.
- **Hole Distances**: Get accurate distances for each hole on the course.
- **Scorecard**: Keep track of your performance with a digital scorecard.

---

## Architecture

### MVVM

ParPals follows the **Model-View-ViewModel (MVVM)** design pattern. This pattern helps separate concerns and makes the application easier to maintain and test.

- **Model**: Represents the data and business logic of the application. It communicates with the Firebase backend to store and retrieve user data, party information, and golf statistics.
- **View**: The UI of the application. It displays the data to the user and listens for user input.
- **ViewModel**: Acts as an intermediary between the View and Model. It manages the data logic and ensures the View is updated with the correct data from the Model.

By using MVVM, ParPals allows for a clean separation between the UI (View) and the application logic (Model), improving maintainability and scalability.

### Firebase

ParPals leverages **Firebase** as its backend solution for real-time data storage and user authentication. Here's how Firebase is utilized:

- **Authentication**: Firebase Authentication is used for user sign-in and sign-up processes, allowing users to securely log in to their ParPals accounts using their email or social media accounts.
- **Realtime Database**: Firebase's real-time database helps manage party system functionalities, allowing users to see live updates as they join or create parties.

Firebase ensures that ParPals has fast, reliable, and scalable backend support.

---

## Views

### Dashboard

The **Dashboard** is the main screen of the app. It provides an overview of the user's golf activities, upcoming parties, and other important information.

![Dashboard](https://github.com/user-attachments/assets/2a375a60-f8f0-4a88-8a6e-26757f9627b1)

### Profile

The **Profile** view allows users to create and manage their golf profiles, including their handicap, name, and stats.

![Profile](https://github.com/user-attachments/assets/2ba5df14-2621-4617-a64d-fbd910ea5b9c)

### Join Party

The **Join Party** screen lets users browse available parties and join one that suits them. You can see the party details and participants here.

![Join Party](https://github.com/user-attachments/assets/5c6d7409-dad3-46a1-8fab-20ed2abad7f0)

### Create Party

On the **Create Party** screen, users can create a new party, set up the details, and invite their friends or make the party public for others to join.

![Create Party](https://github.com/user-attachments/assets/cba04eb3-cc0a-4522-85f8-0165b99dd9cb)

### Map

The **Map** view shows a detailed map of local courses, allowing users to navigate to the golf course and get course details.

![Map](https://github.com/user-attachments/assets/080bb8d7-0cae-4312-96bb-948a102efac8)

### Holes

The **Holes** view gives users detailed information about each hole on the course, including distances and hole types.

![Holes](https://github.com/user-attachments/assets/9b892a78-8b03-465a-b17b-3ce6d0ef9192)

### Scorecard

The **Scorecard** screen is where users can track their performance during a round of golf, keeping a digital scorecard with their strokes on each hole.

![Scorecard](https://github.com/user-attachments/assets/041cec55-98ac-49dd-9493-47d879e5bf90)

---

## Getting Started

To get started with ParPals, clone the repository.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/CharlesDeda/ParPals.git

