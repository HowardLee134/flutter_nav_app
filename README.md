


# How to Set Up and Run the Flutter Project

Follow these steps to set up and run the Flutter project on your local machine.

## 1. Watch the YouTube Video to Install and Set Up Flutter Environment
If you haven't set up Flutter before, follow this [YouTube guide](https://www.youtube.com/watch?v=CvaBru9s9Co&t=580s) to install and configure the environment on your Mac. It will walk you through downloading Flutter, setting up VS Code, and configuring Android and iOS emulators.

## 2. Clone the Project Repository to Your Local Machine
1. Navigate to the GitHub repository for this project.
2. Copy the repository URL by clicking the `Code` button and selecting the HTTPS link.
3. Open your terminal.
4. Run the following command to clone the repository:
    ```bash
    git clone https://github.com/HowardLee134/flutter_nav_app.git

    ```
5. Navigate into the project directory:
    ```bash
    cd flutter-project-repo
    ```

## 3. Open the Project in VS Code
1. Open Visual Studio Code.
2. Click `File` > `Open Folder` and select the project folder you just cloned.
3. Once the project is loaded, press `Cmd + Shift + P` to open the command palette in VS Code.
4. In the command palette, type:
    ```bash
    Flutter: Launch Emulator
    ```
5. Choose the **Flutter Simulator (Android)** option and launch the Android emulator.

## 4. Install Dependencies and Run the App
1. Open the terminal in VS Code or use the terminal in your system.
2. Navigate to the project folder if you're not already there:
    ```bash
    cd flutter-project-repo
    ```
3. Run the following command to fetch and install all necessary dependencies:
    ```bash
    flutter pub get
    ```
4. To run the app in the emulator, use the following command:
    ```bash
    flutter run
    ```

Once everything is set up, you should see the Flutter app running in the Android emulator.
