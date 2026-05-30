# Unitree G1 development workspace

Unitree G1を動かすための開発環境です。ホストはUbuntu 22.04、開発本体はDocker内のROS 2 Humbleで動かす構成にしています。実機に触る前に、まず状態取得とDDS/ROS 2通信の確認から始めます。

## 何が入るか

- ROS 2 Humble + CycloneDDS
- Unitree公式 `unitree_sdk2`
- Unitree公式 `unitree_sdk2_python`
- Unitree公式 `unitree_ros2`
- Unitree公式 `unitree_mujoco` への導線
- VS Code Dev Container設定

## 初回セットアップ

```bash
git clone https://github.com/holys519/unitree-g1-isaaclab-ros2.git
cd unitree-g1-isaaclab-ros2
bash scripts/bootstrap.sh
bash scripts/dev_up.sh
```

`dev_up.sh`はDockerイメージを作ってコンテナへ入ります。初回はROS 2やCycloneDDSを入れるため時間がかかります。

コンテナ内でUnitree公式リポジトリを取得し、Python SDKを入れます。

```bash
bash scripts/fetch_unitree_repos.sh
bash scripts/install_python_sdk2.sh
bash scripts/build_cpp_sdk2.sh
bash scripts/build_unitree_ros2.sh
source scripts/setup_env.sh
```

VS Codeで開く場合は、このディレクトリを開いて「Reopen in Container」を使えます。Dev Containerの作成時は`fetch_unitree_repos.sh`と`install_python_sdk2.sh`まで自動実行します。

## 実機接続

G1とPCをEthernetで接続します。UnitreeのROS 2手順では、PC側の有線インターフェースを手動IPv4にし、アドレスを`192.168.123.99`、マスクを`255.255.255.0`にします。

インターフェース名を確認します。

```bash
ip -br addr
```

例として`enp3s0`がG1に接続されたNICなら、`.env`をこう変更します。

```bash
UNITREE_NET_IFACE=enp3s0
```

変更後にコンテナへ入り直します。

```bash
docker compose restart g1-dev
bash scripts/enter.sh
source scripts/setup_env.sh
```

まずは読み取りだけ確認します。

```bash
bash scripts/ros2_topic_check.sh
```

トピックが見えたら、`ros2 topic list`で表示された実際の名前を使って状態を読みます。Unitree ROS 2のサンプルをビルド済みなら、G1/H1-2向け低レベル状態取得サンプルも候補です。

```bash
./external/unitree_ros2/example/install/unitree_ros2_example/bin/read_low_state_hg
```

## Python SDKのG1サンプル

利用できるG1サンプルを一覧します。

```bash
bash scripts/list_g1_examples.sh
```

`external/unitree_sdk2_python/example/g1/high_level/`や`low_level/`には、腕・ロコモーション・低レベル制御のサンプルがあります。動作を伴うものが多いので、最初はコードを読んで、実行前に`docs/safety.md`を確認してください。

## シミュレーション

`unitree_mujoco`も取得します。公式READMEでは、SDK2/ROS2/Python SDK2で作った制御プログラムをMuJoCoシミュレータに接続し、実機へ移す前に試す流れが想定されています。ただし現時点の公式説明では主に低レベル開発向けです。

Isaac LabはGitHubには含めず、必要なPCで取得します。

```bash
bash scripts/fetch_isaac_lab.sh
```

取得後は`IsaacLab/`に配置されます。起動方法は`ISAAC_LAB_STARTUP.md`を見てください。

C++版シミュレータを使う場合は、MuJoCoを`~/.mujoco`へ展開し、Unitreeが期待するリンクを作ってからビルドします。

```bash
cd external/unitree_mujoco/simulate
ln -s ~/.mujoco/mujoco-3.3.6 mujoco
cd /workspaces/robot
bash scripts/build_unitree_mujoco.sh
```

## よく使うコマンド

```bash
# コンテナ起動と入室
bash scripts/dev_up.sh

# 既存コンテナへ入る
bash scripts/enter.sh

# 環境診断
bash scripts/doctor.sh

# Unitree公式リポジトリ更新
bash scripts/fetch_unitree_repos.sh

# Isaac Lab取得/更新
bash scripts/fetch_isaac_lab.sh
```

## 参照元

- Unitree SDK2: https://github.com/unitreerobotics/unitree_sdk2
- Unitree SDK2 Python: https://github.com/unitreerobotics/unitree_sdk2_python
- Unitree ROS 2: https://github.com/unitreerobotics/unitree_ros2
- Unitree MuJoCo: https://github.com/unitreerobotics/unitree_mujoco
- Unitree Developer Document Center: https://support.unitree.com/home/en/developer
