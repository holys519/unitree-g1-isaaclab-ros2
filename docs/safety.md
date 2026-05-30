# Unitree G1 safety checklist

Use this checklist before sending any command that can move the robot.

1. Put the G1 in an open area with stable footing.
2. Keep the remote controller and emergency stop within reach.
3. Start with read-only checks: DDS discovery, `ros2 topic list`, state echo, camera, or wireless controller state.
4. Do not run low-level motor examples on real hardware until you understand the joint order, control mode, gains, and how to stop the program.
5. Do not send low-level motor commands while a high-level motion service is also controlling the same joints.
6. Keep one terminal ready to stop the process with `Ctrl+C`.
7. Test new control code in simulation first when possible.
