# nano-godot-demo
An example project using the nano-godot-module, meant to demonstrate how Nano can be used in Godot.

This project currently has a functional Nano wallet implemented entirely in Godot. Note that this wallet has not had any sort of security review, so it is not recommended for storing large amounts of Nano. It mostly serves as a proof of concept demonstrating every aspect of the Nano Godot Plugin. The wallet is fully non-custodial, and can perform local block signing. However, a connection with a Nano Node will be required for block processing (publishing), confirmation tracking, proof of work, etc. We recommend https://madora.io/, but the plugin will work with self-hosted nodes or any other node hosting service.

# Setup
1. Set up and compile the nano-godot-module following instructions here https://github.com/Madora-io/nano-godot-module
2. Clone this repository and import it into Godot
