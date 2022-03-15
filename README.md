# Cloud gaming demo for Anbox Cloud

This project demonstrates a simple cloud gaming service on top of [Anbox Cloud](https://anbox-cloud.io)
that allows users to play Android-based games right from their web browser on any device.

## Overview

The demo consists of two components:

* A backend service written in [Python](https://www.python.org/)
* A web UI based on [Flutter](https://flutter.dev/)

The backend service connects to the Anbox Cloud services and retrieves a list of available applications.
It also takes care of launching the actual streaming sessions on demand.

Inside the web UI, the user can choose from the list of available games and start playing either of them.

## Install

To run the demo, simply complete the following steps:

1. Install the Anbox Cloud Appliance. See the [documentation](https://anbox-cloud.io/docs/tut/installing-appliance) for instructions.
2. SSH to your appliance instance, clone the demo repository and run the installation script:

    ```
    git clone git://github.com/anbox-cloud/cloud-gaming-demo
    cd cloud-gaming-demo
    sudo scripts/install.sh
    ```

The installation takes some time because it fetches and installs a selection of freely available Android
game titles.

At the end, the installation script prints the URL where you can access the demo. Happy gaming!

## Uninstall

In case that you don't want to use the cloud gaming demo any longer you can simply uninstall it from
your Anbox Cloud Appliance by running the following commands

    cd cloud-gaming-demo
    sudo ./uninstall.sh

Afterwards all configuration and the cloud gaming demo itself is removed from the machine.

## Get help & community

If you get stuck deploying the demo or would like some help with Anbox Cloud in general, come and ask on the [Anbox Cloud discourse forum](https://discourse.ubuntu.com/c/anbox-cloud)!

## More information

You can find more information about Anbox Cloud on the [website](https://anbox-cloud.io) and in the
[documentation](https://anbox-cloud.io/docs).

If you're interested in building a real production cloud gaming service, [get in touch](https://anbox-cloud.io/contact-us)!