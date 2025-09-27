> ⚠️ This asset and document are still under construction.

# Resource Based Signal Bus

[![Made with Godot](https://img.shields.io/badge/Made%20with-Godot-478CBF?style=flat&logo=godot%20engine&logoColor=white)](https://godotengine.org)
[![Mastodon Follow](https://img.shields.io/mastodon/follow/109780053447231118?domain=mastodon.gamedev.place)](https://mastodon.gamedev.place/@camperotactico)
[![Kofi](https://img.shields.io/badge/Kofi-F16061.svg?logo=ko-fi&logoColor=white)](https://ko-fi.com/camperotactico)

The objective of a _Signal Bus_ (usually known as "Event Bus" or "Event Channel") is to allow signals between objects without them being directly connected to each other. In _Godot_, a common approach to achieve this is to create a [singleton](https://docs.godotengine.org/es/4.x/tutorials/scripting/singletons_autoload.html) that holds all the signals the nodes of a project can access. This asset offers a better, different approach.

Inspired by the usage of _ScriptableObjects_ as event channels in the _Unity3D_ engine _(Learn about this [here](https://unity.com/how-to/scriptableobjects-event-channels-game-code) and [here](https://youtu.be/raQ3iHhE_Kk?si=c3nBhDf29gk7Mfma&t=1670))_, each signal is contained inside its own resource, _<img src="./icons/ResourceBasedSignalBus.svg" width="16" height="16"> SignalBus_. These can be created and saved into the `res://` directory like any other resource type.

![A screenshot of the _Create New Resource_ window of the Godot editor showing different signal bus types.](./screenshots/create_new_resource_window.png)

> A screenshot of the _Create New Resource_ window of the Godot editor showing different signal bus types.

Instead of connecting/emitting signals through a singleton, a node exports a variable that points to a _<img src="./icons/ResourceBasedSignalBus.svg" width="16" height="16"> SignalBus_ resource and connects/emits through it instead. Some of the benefits of using this approach over regular signals or a singleton are:

- ✅ **Decoupled and Maintainable Design**: Emitter and receiver nodes do not hold references to each other or to a global script. Signals are independent from the rest of the code. _If an emitting script needs to be refactored, renamed or split into smaller pieces, there is no need to fix broken connections on the receiving nodes._

- ✅ **Modular and Scalable**: Scenes do not have to be referenced or modified to include new functionality. _Any new node that references an existing <img src="./icons/ResourceBasedSignalBus.svg" width="16" height="16"> SignalBus will interact with the rest of the scenes that already use it._

- ✅ **Easy to Test**: Because these signal buses are resources, they can be assigned to variables, and they can be created, replaced and destroyed via code. _When writing tests, ensure a game component work as expected by creating and assigning temporary signal buses instead of instantiating all of its dependencies. Assign the signal buses to the component and use them to emit or monitor signals._
- ✅ **Flexible and Granular**: Each signal bus resource is unique from the rest, even if it shares the same _<img src="./icons/ResourceBasedSignalBus.svg" width="16" height="16"> SignalBus_ derived type. _A set of nodes can communicate using the same signal bus, or each have its own isolated one_.

- ✅ **More Visual**: Signals are now just another asset in the `res://` folder. _Designers and artists can use them in their scenes without any coding. On top of that, trying to delete a <img src="./icons/ResourceBasedSignalBus.svg" width="16" height="16"> SignalBus resource will warn about scenes that use them becoming orphan._

## 🧰 Features

- Out of the box, this addon only comes with a resource type for a signal with no arguments, `VoidSignalBus`.

- A _Custom SignalBus Script Creator_ tool is included to help define new resource types for signals that take one or more parameters. By default, this tool is displayed in the left upper right dock of the _Godot_ editor, next to the _Scene_ and _Import_ tabs.

> Custom resource types can also be created manually by extending the `SignalBus` class on a new script. The asset includes a [Script Template](./script_templates/SignalBus/custom_signal_bus_template.gd) to ease the process. )

- The asset also features a new node named _<img src="./icons/SignalBusListener.svg" width="16" height="16"> SignalBusListener_. Its purpose is to allow designers and artists to create responses to signals from the inspector. It connects a _<img src="./icons/ResourceBasedSignalBus.svg" width="16" height="16"> SignalBus_ resource to a method of any `Node` in the scene.

## ⬇️ Installation

1. Download the asset from the `AssetLib` tab in the Godot Editor.

2. Enable the plugin `Project` -> `Project Settings` -> `Plugins` -> `Resource Based Signal Bus`

## 📖 Usage

### Creating and using _<img src="./icons/ResourceBasedSignalBus.svg" width="16" height="16"> SignalBus_ resources.

1 - Right click on the _FileSystem_ panel, then select `Create New -> Resource`. A pop-up will open. In there, search for `SignalBus` and choose a type.

2- To emit a signal through its bus, export a variable that matches the _<img src="./icons/ResourceBasedSignalBus.svg" width="16" height="16"> SignalBus_ type in a script. In the inspector panel, choose the resource to use. Finally, call the `emit(...)` method providing the required arguments.

3- To receive a signal through its bus, export a variable that matches the _<img src="./icons/ResourceBasedSignalBus.svg" width="16" height="16"> SignalBus_ type in a script. In the inspector panel, choose the signal bus to use. Then override the `_enter_tree()` and `_exit_tree()` methods and use them to connect and disconnect from to the signal bus using `add_connection(...)` and `remove_connection(...)` and provide them with the callback to use.

![A screenshot of the Godot editor showing the code to emit and receive signals.](./screenshots/signal_bus_usage.png)

> A screenshot of the Godot editor showing the code to emit and receive signals

### Using the _<img src="./icons/SignalBusListener.svg" width="16" height="16"> SignalBusListener_ node.

1- Right click on the _Scene_ panel, then select `Add Child Node...`. A pop-up will open. In there, search for _<img src="./icons/SignalBusListener.svg" width="16" height="16"> SignalBusListener_ and press _Create_.

2- In the inspector panel, select a _<img src="./icons/ResourceBasedSignalBus.svg" width="16" height="16"> SignalBus_ to listen to and a target node to send a response. The arguments from the received signal can be forwarded, ignored or extended by using the different available controls. Once the configuration for the arguments is ready, pick a compatible method from the _Callable String Name_ option button.

![A screenshot of the Godot editor showing the listener node responding to a signal and including extra arguments.](./screenshots/signal_bus_listener.png)

> A screenshot of the Godot editor showing the listener node responding to a signal and including extra arguments.

### Crating Custom SignalBus Scripts From The Editor.

![A screenshot of the _CreateCustomSignalBusScriptEditor_ tab of the Godot editor. The tool is filled with parameters to create a custom signal bus type that wraps a `String,Array[Vector3]` signal.](./screenshots/create_custom_signal_bus_script_editor.png)

> A screenshot of the _CreateCustomSignalBusScriptEditor_ tab of the Godot editor. The tool is filled with parameters to create a custom signal bus type that wraps a `String,Array[Vector3]` signal.

### Creating Custom SignalBus Scripts Via Code.

1 - Right click on the _FileSystem_ panel, then select `Create New -> Script`. A pop-up will open. Fill in the different fields so the new class inherits `SignalBus` and uses the custom template included in the asset. Click _Create_.

![A screenshot of the script creation pop-up. In this case, I am going to create a signal that takes two arguments: an int and a Dictionary[String,Color]](./screenshots/create_script_pop_up.png)

> A screenshot of the script creation pop-up. In this case, I am going to create a signal that takes two arguments: an `int` and a `Dictionary[String,Color]` .

2- Once the new script is created, the editor will complain about several errors. This is because some placeholders in the class need to be changed to match the signature of our custom signal.

![A screenshot of the Godot editor showing a bunch of compiler errors when a custom `SignalBus` class is created.](./screenshots/custom_signal_bus_editor_error.png)

> A screenshot of the Godot editor showing a bunch of compiler errors when a custom `SignalBus` class is created.

![A screenshot of the Godot editor showing the custom `SignalBus` class after the placeholders have been replaced with the desired types.](./screenshots/custom_signal_bus_editor_no_errors.png)

> A screenshot of the Godot editor showing the custom `SignalBus` class after the placeholders have been replaced with the desired types.

3- Now, to create and use the new _<img src="./icons/ResourceBasedSignalBus.svg" width="16" height="16"> SignalBus_ type, simply follow [the steps above](#creating-and-using--signalbus-resources).

## 🐛 Limitations, known issues, bugs

Perhaps the biggest limitation of this project is that I haven't found a way to emit signals from the editor while the game is running. This would be an amazing addition which would ease the testing while developing a project.
