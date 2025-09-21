> ⚠️ This document (and asset) is still under construction.

# <img src="./addons/resource_based_signal_bus/icons/ResourceBasedSignalBus.svg" width="32" height="32"> Resource Based Signal Bus

[![Made with Godot](https://img.shields.io/badge/Made%20with-Godot-478CBF?style=flat&logo=godot%20engine&logoColor=white)](https://godotengine.org)
[![Mastodon Follow](https://img.shields.io/mastodon/follow/109780053447231118?domain=mastodon.gamedev.place)](https://mastodon.gamedev.place/@camperotactico)
[![Kofi](https://img.shields.io/badge/Kofi-F16061.svg?logo=ko-fi&logoColor=white)](https://ko-fi.com/camperotactico)

The objective of a _Signal Bus_ (usually known as "Event Bus" or "Event Channel") is to allow communication between objects without them being directly connected to each other. In _Godot_, a common approach of achieving this is by creating a [singleton](https://docs.godotengine.org/es/4.x/tutorials/scripting/singletons_autoload.html) that holds all the signals to be used by the nodes of the project. My intention is to offer an alternative approach inspired by the use of `ScriptableObject` as event channels in the _Unity3D_ engine. _(Learn about this [here](https://unity.com/how-to/scriptableobjects-event-channels-game-code) and [here](https://youtu.be/raQ3iHhE_Kk?si=c3nBhDf29gk7Mfma&t=1670))_

This asset allows for `SignalBus` resources to be created in the `res://` folder. These resources wrap a signal and can be assigned to any node straight from the inspector panel. Instead of connecting/emitting the signal in a singleton, the nodes connect/emit the signal inside the `SignalBus` resource they are given.

Some of the benefits of using this asset instead of regular signals or a singleton:

- ✅ **Decoupled and Maintainable design**: Emitter and receiver nodes do not hold references to each other. Signals are independent from the rest of the code. If a script needs to be refactored, renamed or split into smaller pieces, there is no need to fix connections to signals.

- ✅ **Modular and Scalable**: Scenes do not have to be modified to include new functionality. Any new scene that references an existing `SingalBus` will interact with the the rest of the scenes that already use it. 

- ✅ **Easy to Test**: These signal buses can be created and destroyed via code. Ensure a game component work as expected by creating temporary signal buses along with it instead of instantiating all of its dependencies. Assign the signal buses to the component and use them to emit or monitor signals.
	
- ✅ **Flexibility and Granularity**: Each signal bus resource is unique from the rest. A set of nodes can communicate using the same signal bus, or each have its own isolated one.


## 🧰 Features
- Comes with typed implementations for the most popular variant types in _Godot_: `VoidSignalBus`, `IntSignalBus`, `FloatSignalBus`, `BoolSignalBus`, `Vector2SignalBus`, `Vector3SignalBus`, `ArraySignalBus`, `DictionarySignalBus`...
- Includes a [Script Template](./script_templates/SignalBus/custom_signal_bus_template.gd) to ease the process of creating custom signal buses. 
- Features a new node named `SignalBusListener`. It connects a `SignalBus` resource to a method of a `Node` in the scene. This allows designers and artists to create responses to signals from the inspector.


## 🐛 Limitations, known issues, bugs

## ⬇️ Installation

1. Download the asset from the `AssetLib` tab in the Godot Editor.
2. Enable the plugin `Project` -> `Project Settings` -> `Plugins` -> `Resource Based Signal Bus`

## 📖 Usage
