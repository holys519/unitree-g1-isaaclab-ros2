# dimos-go2

Standalone DimOS container for Unitree Go2 mapping/navigation.

This is intentionally separate from IsaacLab and ROS 2 so their Python and CUDA
dependencies do not get mixed together.

## Build and start

```bash
git clone https://github.com/<your-account>/<your-repo>.git
cd <your-repo>/dimos-go2
cp .env.example .env
docker compose up -d --build
```

The container starts idle. It does not launch DimOS until you run a command.

## Enter

```bash
docker exec -it dimos-go2-cu124 bash
```

## Try a replay

```bash
dimos --replay run unitree-go2
```

The first replay run may download recorded Go2 data.

## Run with a real Go2

```bash
export ROBOT_IP=<YOUR_GO2_IP>
dimos run unitree-go2
```

With host networking, the web UI should be reachable from the host browser at:

```text
http://localhost:7779
```
