[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<p align="center">
  <img src="./docs/assets/img/robotnik-logo.png" alt="Robotnik logo" height="80">
</p>

<h1 align="center"></h1>

## Overview
Simulation-based environments and launch assets for Robotnik platforms on ROS 2.

<p align="center">
  <img src="./docs/assets/img/RBVogui_Docking.gif" alt="RBVogui Docking Simulation" height="300">
</p>

## Supported Robots

| Robot | Robot Model | Kinematics | Photos |
|-------|-------------|------------|-------|
| [RB-WATCHER](https://robotnik.eu/robotnik-robots/RB-WATCHER/) | rbwatcher | `skid-steering` | <img src="docs/assets/robots/rb-watcher.png" alt="RB-WATCHER" width=100> |
| [RB-SUMMIT](https://robotnik.eu/products/mobile-robots/rb-summit/) | rbsummit | `skid-steering` | <img src="docs/assets/robots/rb-summit-xl.png" alt="RB-SUMMIT" width=100> |
| [RB-VOGUI](https://robotnik.eu/robotnik-robots/rb-vogui/) | rbvogui, rbvogui_plus | `omni-directional`, `ackermann` | <img src="docs/assets/robots/rb-vogui.png" alt="RB-VOGUI" width=100> |
| [RB-VOGUI-XL](https://robotnik.eu/robotnik-robots/rb-vogui-xl/) | rbvogui_xl | `omni-directional`, `ackermann` | <img src="docs/assets/robots/rb-vogui-xl.png" alt="RB-VOGUI-XL" width=100> |
| [RB-FIQUS](https://robotnik.eu/robotnik-robots/rb-fiqus/) | rbfiqus | `omni-directional`, `ackermann` | <img src="docs/assets/robots/rb-fiqus.png" alt="RB-FIQUS" width=100> |
| [RB-KAIROS](https://robotnik.eu/robotnik-robots/rb-kairos/) | rbkairos, rbkairos_plus | `omni-directional` | <img src="docs/assets/robots/rb-kairos.png" alt="RB-KAIROS" width=100> |
| [RB-ROBOUT](https://robotnik.eu/robotnik-robots/rb-robout/) | rbrobout, rbrobout_plus | `omni-directional` | <img src="docs/assets/robots/rb-robout.png" alt="RB-ROBOUT" width=100> |
| [RB-1*](https://robotnik.eu/robotnik-robots/rb-1/) | rb1 | `differential` | <img src="docs/assets/robots/rb-1.png" alt="RB-1 (discontinued)" width=100> |
| [RB-THERON](https://robotnik.eu/robotnik-robots/rb-theron/) | rbtheron, rbtheron_plus | `differential` | <img src="docs/assets/robots/rb-theron.png" alt="RB-THERON" width=100> |
| [RB-CAR](https://robotnik.eu/wp-content/uploads/2023/01/Robotnik-RB-CAR-Datasheet-221226-EN.pdf) | rbcar | `ackermann` | <img src="docs/assets/robots/rb-car.png" alt="RB-CAR" width=100> |

*Note: The RB-1 robot is discontinued and may not be supported in future releases.*

## Available Simulators

| Simulator | Package | Instructions |
|-----------|---------|--------------|
| <a href="robotnik_gazebo_ignition/README.md"><img src="docs/assets/img/gazebo-logo.png" alt="Gazebo Logo" height=50></a> | `robotnik_gazebo_ignition` | [README](robotnik_gazebo_ignition/README.md)


## Quick start

### Installation

Before launching the simulation, ensure that the installation steps for one of the available simulators listed above have been completed.

### Docker

If you want to run the integrated simulation in Docker, the current workflow is documented in [`docker/README.md`](docker/README.md).

That guide covers:

- running the published image from Docker Hub
- building an image that copies only this repository from the local machine and pulls any extra required repositories from `dependencies/repos/robotnik_simulation.jazzy.repos`
- editing [`env/robot.env`](env/robot.env) to choose robot, world, GUI and RViz options
- opening a second terminal with `docker exec` to interact with the running simulation from inside the runtime container

### Pixi (ROS 2 Lyrical, no system ROS)

Runs RB-Kairos on ROS 2 Lyrical and Gazebo Ionic from a self-contained [pixi](https://pixi.sh) environment. Nothing is installed outside the repository apart from pixi itself. Supported robots on this path: `rbkairos`, `rbkairos_plus` (and `rbcar`, untested). Other robots still need `robotnik_controllers`, which has no Lyrical build.

Requirements: Linux x86_64, glibc 2.34 or newer, a GPU or software OpenGL, about 8 GB of disk for the environment, and a terminal attached to a graphical session (`echo $DISPLAY` prints a value). Plain SSH sessions can only run with `--gui false` and `--run_rviz false`.

```bash
# 1. pixi, once. Restart the shell afterwards.
curl -fsSL https://pixi.sh/install.sh | sh

# 2. Clone this repository (the branch carrying the Lyrical port).
git clone -b feature/lyrical/PortToLyrical https://github.com/kaushikbalasundar/robotnik_simulation.git
cd robotnik_simulation

# 3. Create the environment (several minutes, downloads a few GB).
pixi install

# 4. Fetch the dependency repositories into ../robotnik_ws/src and build.
pixi run import-repos
pixi run colcon-build

# 5. Run, one command per terminal.
pixi run spawn-world                 # Gazebo Ionic; add --world demo or --gui false
pixi run spawn-rbkairos              # robot + RViz; add --robot_model rbkairos_plus or --run_rviz false
pixi run teleop                      # keyboard teleop, TwistStamped on /robot/robotnik_base_control/cmd_vel
```

Expected result: the robot appears in Gazebo, `ros2 topic hz /robot/robotnik_base_control/odom` reports about 50 Hz inside `pixi shell`, and the robot moves when keys are pressed in the teleop terminal or the RViz teleop panel is enabled.

The dependency list is [`dependencies/repos/robotnik_simulation.lyrical.repos`](dependencies/repos/robotnik_simulation.lyrical.repos). Two entries point at forks with changes not yet upstream (`robotnik_description`: mecanum controller type for rbkairos; `teleop_panel`: Qt6 build). Rebuild after editing anything with `pixi run colcon-build`.

### Bringup

Launch complete simulation:

```
ros2 launch  robotnik_simulation_bringup bringup_complete.launch.py robot_model:=rbsummit
```

![alt text](common/robotnik_simulation_bringup/docs/summit-rviz.png)

### Additional Configuration

For a complete description of available parameters and files, refer to the `robotnik_simulation_bringup` [README](common/robotnik_simulation_bringup/README.md).


## Related projects

Projects built upon this repository:

- 🕹️ [`robotnik_o3de`](https://github.com/RobotnikAutomation/robotnik_o3de): [O3DE](https://o3de.org/)-based simulation.
- 🐞 [`robotnik_webots`](https://github.com/RobotnikAutomation/robotnik_webots): [Webots](https://cyberbotics.com/) based simulation.
- 🟢 [`robotnik_isaac`](https://github.com/RobotnikAutomation/robotnik_isaac): [Isaac Sim](https://developer.nvidia.com/isaac-sim) based simulation.
- 🎮 [`robotnik_unity`](https://github.com/RobotnikAutomation/robotnik_unity): [Unity](https://unity.com/) based simulation.

## Contributing

Contributions are welcome.

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/jazzy/AmazingFeature`
3. Commit: `git commit -m "Add AmazingFeature"`
4. Push: `git push origin feature/AmazingFeature`
5. Open a PR and describe your changes


Special thanks to all contributors!

<a href="https://github.com/RobotnikAutomation/robotnik_simulation/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=RobotnikAutomation/robotnik_simulation" alt="Contributors graph" />
</a>

## License

Distributed under **BSD-3**. See [`LICENSE`][license-url].

<!-- LINK REFS -->

[contributors-shield]: https://img.shields.io/github/contributors/RobotnikAutomation/robotnik_simulation.svg?style=for-the-badge
[contributors-url]: https://github.com/RobotnikAutomation/robotnik_simulation/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/RobotnikAutomation/robotnik_simulation.svg?style=for-the-badge
[forks-url]: https://github.com/RobotnikAutomation/robotnik_simulation/network/members
[stars-shield]: https://img.shields.io/github/stars/RobotnikAutomation/robotnik_simulation.svg?style=for-the-badge
[stars-url]: https://github.com/RobotnikAutomation/robotnik_simulation/stargazers
[issues-shield]: https://img.shields.io/github/issues/RobotnikAutomation/robotnik_simulation.svg?style=for-the-badge
[issues-url]: https://github.com/RobotnikAutomation/robotnik_simulation/issues
[license-shield]: https://img.shields.io/github/license/RobotnikAutomation/robotnik_simulation.svg?style=for-the-badge
[license-url]: LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/company/robotnik-automation/
[product-screenshot]: docs/assets/img/ignition_simulation_view.png
