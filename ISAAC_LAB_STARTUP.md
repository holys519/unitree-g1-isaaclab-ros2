# Isaac Lab startup notes

Isaac Labは`<workspace>/IsaacLab`にあります。
ディレクトリがない場合は先に取得します。

```bash
cd /path/to/unitree-g1-isaaclab-ros2
bash scripts/fetch_isaac_lab.sh
```

SSHで使う場合はGUIなしの`--headless`を基本にします。

## 基本操作

```bash
cd /path/to/unitree-g1-isaaclab-ros2/IsaacLab

# コンテナ起動
./docker/container.py start

# コンテナに入る
./docker/container.py enter

# コンテナ停止
./docker/container.py stop
```

## SSH環境での注意

SSH先で`DISPLAY`が空のときは、X11 forwardingを有効にしないでください。
聞かれた場合は`N`を選びます。

設定を手で戻す場合:

```bash
cd /path/to/unitree-g1-isaaclab-ros2/IsaacLab
sed -i 's/x11_forwarding_enabled = 1/x11_forwarding_enabled = 0/' docker/.container.cfg
```

## GUIで起動する

リモートデスクトップ内のターミナルで実行します。純SSHのターミナルではなく、
GUIセッション側のターミナルを使うのが安全です。

まずホスト側でGUIとGPUを確認します。

```bash
echo "$DISPLAY"
nvidia-smi
```

`DISPLAY`に`:0`や`:10.0`のような値が出て、`nvidia-smi`がGPU情報を表示すれば次へ進みます。

X11 forwardingを有効にします。

```bash
cd /path/to/unitree-g1-isaaclab-ros2/IsaacLab
sed -i 's/x11_forwarding_enabled = 0/x11_forwarding_enabled = 1/' docker/.container.cfg
```

コンテナを起動し、入ります。

```bash
./docker/container.py start
./docker/container.py enter
```

Isaac Sim本体をGUIで開く場合:

```bash
./isaaclab.sh -s
```

Isaac LabのチュートリアルをGUIで開く場合は、`--headless`を付けずに実行します。

```bash
./isaaclab.sh -p scripts/tutorials/00_sim/create_empty.py
```

G1環境をGUIで動かす場合:

```bash
./isaaclab.sh -p scripts/environments/list_envs.py | grep -i g1
./isaaclab.sh -p scripts/environments/random_agent.py --task Isaac-Velocity-Flat-G1-v0 --num_envs 1
```

環境名は`list_envs.py`の出力に合わせて変更してください。

画面が開かずX11権限で失敗する場合は、ホスト側で一時的に次を試します。

```bash
xhost +local:docker
```

作業後に戻す場合:

```bash
xhost -local:docker
```

## 起動確認

コンテナに入ったあと、まずはヘッドレスで空シーンを起動します。

```bash
./isaaclab.sh -p scripts/tutorials/00_sim/create_empty.py --headless
```

## G1環境を探す

```bash
./isaaclab.sh -p scripts/environments/list_envs.py | grep -i g1
```

G1環境名が見つかったら、例としてランダムエージェントをヘッドレスで動かします。
環境名は手元の出力に合わせて変更してください。

```bash
./isaaclab.sh -p scripts/environments/random_agent.py --task Isaac-Velocity-Flat-G1-v0 --headless
```

## G1シミュレーション最短コマンド

コンテナ内で実行します。

```bash
cd /workspace/isaaclab
```

まずG1モデル表示だけ確認します。

```bash
./isaaclab.sh -p scripts/demos/bipeds.py
```

G1の平地歩行タスクを1体で起動します。

```bash
./isaaclab.sh -p scripts/environments/zero_agent.py \
  --task Isaac-Velocity-Flat-G1-Play-v0 \
  --num_envs 1
```

ランダム入力でG1を動かします。

```bash
./isaaclab.sh -p scripts/environments/random_agent.py \
  --task Isaac-Velocity-Flat-G1-Play-v0 \
  --num_envs 1
```

複数体で確認します。

```bash
./isaaclab.sh -p scripts/environments/random_agent.py \
  --task Isaac-Velocity-Flat-G1-Play-v0 \
  --num_envs 8
```

G1タスク一覧を確認します。

```bash
./isaaclab.sh -p scripts/environments/list_envs.py --keyword G1
```

G1で短く学習します。

```bash
./isaaclab.sh -p scripts/reinforcement_learning/rsl_rl/train.py \
  --task Isaac-Velocity-Flat-G1-v0 \
  --num_envs 512 \
  --max_iterations 200 \
  --headless
```

RTX 3090 x2でG1を学習します。

```bash
CUDA_VISIBLE_DEVICES=0,1 python -m torch.distributed.run \
  --nnodes=1 \
  --nproc_per_node=2 \
  scripts/reinforcement_learning/rsl_rl/train.py \
  --task Isaac-Velocity-Flat-G1-v0 \
  --num_envs 4096 \
  --max_iterations 1500 \
  --headless \
  --distributed
```

最初に試す順番は、`bipeds.py`、`zero_agent.py`、`random_agent.py`です。
`random_agent.py`は制御性能の確認ではなく、シミュレーション環境が動くかを見るための確認です。

## シミュレーションの進め方

GUIが動いたら、次の順番で確認します。

1. G1モデルを表示する
2. G1のタスク環境を動かす
3. 必要なら強化学習する
4. 学習済みポリシーをGUIで再生する

### 1. G1モデルを表示する

まずはG1がIsaac Lab上でロードできるか確認します。

```bash
cd /workspace/isaaclab
./isaaclab.sh -p scripts/demos/bipeds.py
```

このデモではCassie、H1、G1が並んで表示されます。
まずはモデル表示、物理更新、カメラ操作が問題ないかを見ます。

### 2. G1タスク環境を動かす

G1関連タスクを一覧します。

```bash
./isaaclab.sh -p scripts/environments/list_envs.py --keyword G1
```

最初は平地歩行のPlay環境を1体だけ動かすのがおすすめです。

```bash
./isaaclab.sh -p scripts/environments/zero_agent.py \
  --task Isaac-Velocity-Flat-G1-Play-v0 \
  --num_envs 1
```

ゼロ入力ではうまく歩きませんが、環境が正常に作られるか確認できます。

ランダム入力で動作確認する場合:

```bash
./isaaclab.sh -p scripts/environments/random_agent.py \
  --task Isaac-Velocity-Flat-G1-Play-v0 \
  --num_envs 1
```

ランダム入力なので、転倒したり不自然な動きをします。
これは制御性能の確認ではなく、シミュレーション環境の疎通確認です。

### 3. 強化学習する

学習はGUIなしのほうが速いです。まず短めに試します。

```bash
./isaaclab.sh -p scripts/reinforcement_learning/rsl_rl/train.py \
  --task Isaac-Velocity-Flat-G1-v0 \
  --num_envs 512 \
  --max_iterations 200 \
  --headless
```

本格的に学習する場合は`--max_iterations`を増やします。
G1 flatの設定ではデフォルト最大iterationは`1500`です。

学習ログは通常ここに保存されます。

```bash
ls logs/rsl_rl/g1_flat
```

### 4. 学習済みポリシーをGUIで再生する

学習後、run名とcheckpointを確認します。

```bash
find logs/rsl_rl/g1_flat -name "model_*.pt" | sort
```

見つかったcheckpointを指定してGUIで再生します。

```bash
./isaaclab.sh -p scripts/reinforcement_learning/rsl_rl/play.py \
  --task Isaac-Velocity-Flat-G1-Play-v0 \
  --num_envs 1 \
  --checkpoint logs/rsl_rl/g1_flat/<RUN_NAME>/model_<ITERATION>.pt
```

`<RUN_NAME>`と`<ITERATION>`は実際のファイル名に置き換えてください。

### よく使うG1タスク

```bash
# 平地歩行
Isaac-Velocity-Flat-G1-v0
Isaac-Velocity-Flat-G1-Play-v0

# 不整地歩行
Isaac-Velocity-Rough-G1-v0
Isaac-Velocity-Rough-G1-Play-v0

# Pick & Place / Locomanipulation
Isaac-PickPlace-G1-InspireFTP-Abs-v0
Isaac-PickPlace-FixedBaseUpperBodyIK-G1-Abs-v0
Isaac-PickPlace-Locomanipulation-G1-Abs-v0
```

## RTX 3090 x2でマルチGPU学習する

Isaac LabのDocker設定は、デフォルトで全GPUをコンテナへ渡す設定になっています。
まずホスト側でGPUが2枚見えているか確認します。

```bash
nvidia-smi
```

コンテナに入ります。

```bash
cd /path/to/unitree-g1-isaaclab-ros2/IsaacLab
./docker/container.py start
./docker/container.py enter
cd /workspace/isaaclab
```

コンテナ内でも2枚見えるか確認します。

```bash
nvidia-smi
python - <<'PY'
import torch
print("cuda:", torch.cuda.is_available())
print("gpu_count:", torch.cuda.device_count())
for i in range(torch.cuda.device_count()):
    print(i, torch.cuda.get_device_name(i))
PY
```

### G1の人数を増やしてGUI確認する

`--num_envs`が同時に出す環境数です。G1タスクなら、ほぼ「G1の人数/体数」と考えてよいです。
GUI表示では重くなりやすいので、まずは`4`、`8`、`16`の順に増やします。

```bash
# 4体
./isaaclab.sh -p scripts/environments/zero_agent.py \
  --task Isaac-Velocity-Flat-G1-Play-v0 \
  --num_envs 4

# 8体
./isaaclab.sh -p scripts/environments/zero_agent.py \
  --task Isaac-Velocity-Flat-G1-Play-v0 \
  --num_envs 8

# 16体
./isaaclab.sh -p scripts/environments/zero_agent.py \
  --task Isaac-Velocity-Flat-G1-Play-v0 \
  --num_envs 16
```

ランダム入力で複数体を動かす場合:

```bash
./isaaclab.sh -p scripts/environments/random_agent.py \
  --task Isaac-Velocity-Flat-G1-Play-v0 \
  --num_envs 16
```

さらに増やす場合:

```bash
./isaaclab.sh -p scripts/environments/random_agent.py \
  --task Isaac-Velocity-Flat-G1-Play-v0 \
  --num_envs 32
```

GUI表示はレンダリング負荷が高いので、学習目的なら次のヘッドレス実行を使います。

### 2GPUでG1を学習する

2枚のRTX 3090を使う場合は、`torch.distributed.run`で2プロセス起動し、
Isaac Lab側に`--distributed`を渡します。

```bash
python -m torch.distributed.run \
  --nnodes=1 \
  --nproc_per_node=2 \
  scripts/reinforcement_learning/rsl_rl/train.py \
  --task Isaac-Velocity-Flat-G1-v0 \
  --num_envs 2048 \
  --max_iterations 1500 \
  --headless \
  --distributed
```

`--nproc_per_node=2`がGPU数です。RTX 3090 x2なら`2`にします。
`--num_envs 2048`は合計の並列環境数です。重い場合は`1024`へ下げます。

軽めの動作確認:

```bash
python -m torch.distributed.run \
  --nnodes=1 \
  --nproc_per_node=2 \
  scripts/reinforcement_learning/rsl_rl/train.py \
  --task Isaac-Velocity-Flat-G1-v0 \
  --num_envs 1024 \
  --max_iterations 100 \
  --headless \
  --distributed
```

不整地歩行を2GPUで学習する場合:

```bash
python -m torch.distributed.run \
  --nnodes=1 \
  --nproc_per_node=2 \
  scripts/reinforcement_learning/rsl_rl/train.py \
  --task Isaac-Velocity-Rough-G1-v0 \
  --num_envs 2048 \
  --max_iterations 3000 \
  --headless \
  --distributed
```

GPUを明示したい場合:

```bash
CUDA_VISIBLE_DEVICES=0,1 python -m torch.distributed.run \
  --nnodes=1 \
  --nproc_per_node=2 \
  scripts/reinforcement_learning/rsl_rl/train.py \
  --task Isaac-Velocity-Flat-G1-v0 \
  --num_envs 2048 \
  --max_iterations 1500 \
  --headless \
  --distributed
```

### さらに速く学習する

Isaac LabのRL学習には、単純な`--speed 2`のような倍速フラグはありません。
学習を速くする基本は、GUIを切ることと、`--num_envs`を増やして同時に集める経験数を増やすことです。

現在の基準を`--num_envs 2048`とするなら、倍速狙いは`4096`です。
RTX 3090 x2ではVRAMを見ながら、`3072`、`4096`の順に上げます。

中間設定:

```bash
CUDA_VISIBLE_DEVICES=0,1 python -m torch.distributed.run \
  --nnodes=1 \
  --nproc_per_node=2 \
  scripts/reinforcement_learning/rsl_rl/train.py \
  --task Isaac-Velocity-Flat-G1-v0 \
  --num_envs 3072 \
  --max_iterations 1500 \
  --headless \
  --distributed
```

倍速狙い:

```bash
CUDA_VISIBLE_DEVICES=0,1 python -m torch.distributed.run \
  --nnodes=1 \
  --nproc_per_node=2 \
  scripts/reinforcement_learning/rsl_rl/train.py \
  --task Isaac-Velocity-Flat-G1-v0 \
  --num_envs 4096 \
  --max_iterations 1500 \
  --headless \
  --distributed
```

短時間で動作確認する場合:

```bash
CUDA_VISIBLE_DEVICES=0,1 python -m torch.distributed.run \
  --nnodes=1 \
  --nproc_per_node=2 \
  scripts/reinforcement_learning/rsl_rl/train.py \
  --task Isaac-Velocity-Flat-G1-v0 \
  --num_envs 4096 \
  --max_iterations 100 \
  --headless \
  --distributed
```

不整地歩行で速く学習する場合:

```bash
CUDA_VISIBLE_DEVICES=0,1 python -m torch.distributed.run \
  --nnodes=1 \
  --nproc_per_node=2 \
  scripts/reinforcement_learning/rsl_rl/train.py \
  --task Isaac-Velocity-Rough-G1-v0 \
  --num_envs 3072 \
  --max_iterations 3000 \
  --headless \
  --distributed
```

```bash
CUDA_VISIBLE_DEVICES=0,1 python -m torch.distributed.run \
  --nnodes=1 \
  --nproc_per_node=2 \
  scripts/reinforcement_learning/rsl_rl/train.py \
  --task Isaac-Velocity-Rough-G1-v0 \
  --num_envs 3072 \
  --max_iterations 3000 \
  --distributed
```


学習中は別ターミナルでGPU使用量を見ます。

```bash
watch -n 1 nvidia-smi
```

メモリ不足や速度低下が出る場合は、`--num_envs`を下げます。

```bash
# 安定側
--num_envs 2048

# 中間
--num_envs 3072

# 倍速狙い
--num_envs 4096
```

GUIを開いたままの学習、`--video`付き学習、カメラ有効化は遅くなります。
速度重視の学習では、`--headless`だけで実行します。

### 学習済みポリシーを多人数でGUI再生する

学習後、checkpointを確認します。

```bash
find logs/rsl_rl/g1_flat -name "model_*.pt" | sort
```

8体で再生する例:

```bash
./isaaclab.sh -p scripts/reinforcement_learning/rsl_rl/play.py \
  --task Isaac-Velocity-Flat-G1-Play-v0 \
  --num_envs 8 \
  --checkpoint logs/rsl_rl/g1_flat/<RUN_NAME>/model_<ITERATION>.pt
```

32体で再生する例:

```bash
./isaaclab.sh -p scripts/reinforcement_learning/rsl_rl/play.py \
  --task Isaac-Velocity-Flat-G1-Play-v0 \
  --num_envs 32 \
  --checkpoint logs/rsl_rl/g1_flat/<RUN_NAME>/model_<ITERATION>.pt
```

### NCCLエラーが出る場合

マルチGPU学習でNCCLエラーが出る場合は、コンテナ内で次を設定してから再実行します。

```bash
export NCCL_SHM_DISABLE=1
```

まだ失敗する場合:

```bash
export NCCL_IB_DISABLE=1
export NCCL_ALGO=Ring
```

## よくある確認

Isaac Sim / Isaac Labの実行にはNVIDIA GPUとドライバが必要です。
ホスト側で次が通るか確認します。

```bash
nvidia-smi
docker --version
docker compose version
```

`nvidia-smi`が失敗する場合は、先にNVIDIAドライバやコンテナGPUランタイムを直します。
