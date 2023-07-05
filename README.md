# Cooperative-robotics-simulation

![Image](./Cooperative-robotics-simulation.png)

This project is the result of my undergraduate thesis in Mechatronics Engineering. Developed in MATLAB and based on the [mGaia agent oriented software engineering (AOSE) methodology](https://ieeexplore.ieee.org/abstract/document/1290487), it simulates a Multi-Agent System (MAS) algorithm in which two robots cooperate by communicating and coordinating their movements to transport an object too large to be carried individually. 

The simulation accounts for robot kinematics and sensor operation, and allows the user to monitor both robots' coordinates and message exchanges, as well as generating events such as path obstacles and loss of communication between the robots.

The source files in this project are registered on my behalf at [Unversidad Militar Nueva Granada](https://repository.unimilitar.edu.co/handle/10654/6712), and are thus confidential and for demonstration purposes only. Please refer to the [license](./LICENSE) for more details.

The [media](./media) folder contains video recordings of the simulation. 

To interact with the simulation, you must install MATLAB and perform the following steps:

1. Download the [src](./src) folder.
2. Open MATLAB and navigate to the location where the folder was downloaded.
3. Start the simulation by typing `run(AmbienteVirtual)` in the "Command Window" or by double-clicking AmbienteVirtual.m in the left-side navigation pane.
