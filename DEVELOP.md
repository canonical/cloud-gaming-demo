# Development

This document shows how to customise the demo and add your own changes.
It describes how to build the web UI, configure the backend service, run the demo with your local changes and add additional games.

NOTE: This document assumes that you have installed the [Anbox Cloud Appliance](https://anbox-cloud.io/docs/ref/glossary#anbox-cloud-appliance) on your local machine. Follow the [instructions](https://anbox-cloud.io/docs/tut/installing-appliance) on how to install it if you haven't.

## Web UI

The web UI for the cloud gaming demo is built with [Flutter](https://flutter.dev/).
To set up the development environment and build the UI, make sure that you have Flutter installed on your machine.
Follow the [installation instructions](https://docs.flutter.dev/get-started/install/linux) to install it.

### Build the web UI

To build the UI, simply run:

  ```
  cd ui && flutter build web
  ```

This builds the UI and places outputs in the `ui/build/web` directory.
Refer to the official [documentation](https://docs.flutter.dev/get-started/web) for details on how to build web apps with Flutter.

### Deploy the web UI

Create a `static` folder under the `backend/service` directory and copy everything that is in the `ui/build/web` directory into it.

  ```
  mkdir -p backend/service/static
  cp -av ui/build/web/* backend/service/static
  ```

The backend service will then serve those static resources when you access the web UI.


## Backend

The backend service does not only serve the web UI, but it also interacts with the Anbox Stream Gateway and provides a set of restful APIs for clients (for example, the web UI) to perform operations like listing games or launching a game.

### Install the dependencies

Before you start, install the `virtualenv` package to create an isolated Python environment in which the backend service can run:

  ```
  sudo apt-get install python3-pip
  sudo pip3 install virtualenv
  cd backend && virtualenv venv
  ```

### Configure the service

To access the APIs that are exposed by the Anbox Stream Gateway, the backend service must know the following information:

- The URL of the Anbox Stream Gateway
- The access token for the Anbox Stream Gateway Restful API authentication

Create a file called `config.yaml` that contains those two configuration items:

   ```
   gateway-url: https://<machine public address>
   gateway-token: <gateway_token>
   ```

The gateway token can be obtained from the following command:

   ```
   anbox-cloud-appliance gateway account create <account-name>
   ```

Then add the following line to the `activate` hook in the `backend/venv/bin/` directory so that the backend service can read the `config.yaml` on its startup:

   ```
   export CONFIG_PATH=<path_to_config_yaml>
   ```

## Run the demo with your changes

To run the demo, launch the backend service with the following script:

   ```
   cd backend && ./run.sh
   ```

When the backend service is fully up and running, the web UI will be available at `http://0.0.0.0:8002`.


## Add additional games

To add another game to the demo, complete the following steps:

1. Create a folder under the `HOME` directory and create a `manifest.yaml` file in the folder.

2. Add the following content to the manifest file:

   ```
   name: <game-name>
   instance-type: <instance-type>
   ```

   This uses the default image as the base to create the application in [AMS](https://anbox-cloud.io/docs/exp/ams).

   Make sure to choose a suitable [instance type](https://anbox-cloud.io/docs/ref/instance-types) based on the Anbox Cloud Appliance deployment.

3. Rename the APK file to `app.apk` and put it into the root directory of your folder.
   The final layout of the game folder should look as follows:

   ```
   .
   ├── app.apk
   └── manifest.yaml
   ```

4. Run the following command from the folder to create the application in AMS:

    ```
    amc application create  .
    ```

    You can monitor the status of the application creation with the following command:

    ```
    amc application ls
    ```

   When the status of the application changes to `ready`, the game has successfully been created in AMS.

5. To display the game on the web UI, update the `gameids` variable defined in the `ui/lib/homepage.dart` file to include the name of the game (as declared in the manifest file).

   ```
   final gameids = ['bombsquad', 'bbr2', 'mindustry', 'minetest', <game-name>];
   ```

6. Insert a new key/value pair to the static `appNameMap` and `appDesMap` variables defined in the `lib/api/application.dart` file, respectively representing the display name and the description of the game shown on the home page.

   ```
   static Map<String, String> appNameMap = const {
   ...
   ...
   '<game-name>': '<display-name>'
   };

   static Map<String, String> appDesMap = const {
   ...
   ...
   '<game-name>': '<description>'
   };
   ```

7. Provide a screenshot of the game (in jpeg format), rename it to `<game-name>.jpeg` and put it into the `ui/lib/assets` directory.

8. Rebuild the web UI, copy the contents from the `ui/build/web` folder to the `backend/service/static` directory, and refresh the webpage. The game will now be available to use.
