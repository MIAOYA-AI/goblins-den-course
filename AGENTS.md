# Goblins Den Course

Godot 4.7 第一人称地牢探索游戏（学习/课程项目）。

## 引擎与渲染

- **Godot 4.7**（`config/features=PackedStringArray("4.7", "GL Compatibility")`）
- 渲染：**GL Compatibility**（桌面 RD driver = d3d12，mobile = gl_compatibility）。注意不是 Forward+，写 shader/光照/后处理时按 Compatibility 限制来。
- 物理：**Jolt Physics**（3D）
- 语言：**GDScript**（项目里有 `[dotnet]` 段，但所有脚本都是 `.gd`，按 GDScript 处理）
- 输入：WASD + 鼠标（`forward/backward/strafe_left/strafe_right/run/jump/action/use/kick/block/throw/restart`，定义在 `project.godot` 的 `[input]`）

## 架构

```
scenes/
  world/world.tscn              # 世界容器（主场景 uid://du4iytvqujxe7）
  levels/
    bsase_level.gd/.tscn        # BaseLevel：在 %PlayerSpawn 处实例化 Player
    level_01.tscn               # 具体关卡
  rooms/
    base_room.gd/.tscn          # BaseRoom：基于 GridMap 自动补天花板
    entrance.tscn, foyer.tscn   # 房间
  characters/
    player.gd/.tscn             # Player：第一人称控制器（CharacterBody3D + Camera3D）
  ui/ui.tscn                    # UI
```

> 注：`scenes/levels/bsase_level.*` 的 `bsase` 是既有拼写，沿用，不要随手"修正"以免破坏引用。

关键类与数据流：

- **`Player (CharacterBody3D)`** — `_ready()` 锁定鼠标（`MOUSE_MODE_CAPTURED`）；输入在 `_process` 采集（`Input.get_vector`），运动在 `_physics_process` 用 `move_toward` 平滑加速 + `move_and_slide()`；鼠标视角在 `_input` 里 `rotate_y` / `camera.rotate_x` + `clampf` 限角。
- **`BaseLevel (Node3D)`** — `_ready()` 用 `preload` 的 Player 预制体在 `%PlayerSpawn` 处 `instantiate()`。
- **`BaseRoom (Node3D)`** — 两个 GridMap（`%Floors` / `%Ceilings`），按地板格子名（`Ground`、`Hole-Corner`、`Hole-Side`、`Hole-UTurn`）决定哪些格子补天花板。

## 代码规范（沿用现有风格）

- 顶部 `class_name Xxx`（PascalCase）+ `extends NodeType`
- 显式类型：`@export var speed: float = 3.0`、`func _ready() -> void:`；项目已开 `untyped_declaration=1`（无类型会警告）
- 节点引用用 `@onready var x := %UniqueName`（场景唯一名 `%`）
- 预制体 `const PREFAB := preload("res://...")` 再 `.instantiate()`
- 信号解耦：子节点 emit，父节点 connect，不跨层直接引用远节点
- 注释用中文
- **Godot 4 易错点（写代码前先 `godot_search_docs` 查证）**：
  - `move_and_slide()` 无参，`velocity` 是属性
  - `yield()` → `await`；`connect("sig", obj, "m")` → `sig.connect(callable)`
  - `export` → `@export`；`tool` → `@tool`；`instance()` → `instantiate()`
  - `KinematicBody` → `CharacterBody3D`
  - `deg2rad` → `deg_to_rad`；`rand_range` → `randf_range` / `randi_range`

## 资源 / 关卡管线

Blender → `.glb` 网格 → `.meshlib`（MeshLibrary）→ GridMap 拼房间。

- 源：`assets/blender/dungeon-tiles.blend`
- 网格：`assets/meshes/walls/*.glb`
- MeshLibrary：`assets/msehlibs/*.meshlib`（**目录名 `msehlibs` 是既有拼写错误，应为 `meshlibs`；移动/重命名前先全局搜引用**）
- 纹理：`assets/textures/dungeon-texture.png`

## Godot 工具使用指南（全局可用，已在本项目预授权）

涉及 Godot API/场景时优先用这些工具，而不是凭记忆写。

### Skill（`Skill` 工具）

- `godot` — GDScript 2.0（Godot 4.3+）通用入口，强制静态类型与官方风格
- `godot-prompter:*` 插件（v1.12.0）常用：
  - `player-controller` — 玩家移动/控制器（本项目核心）
  - `scene-organization` — 场景继承 vs 组合、何时拆分
  - `3d-essentials` — 3D 材质/光照/雾（注意 Compatibility 限制）
  - `physics-system` — 物理/Jolt/碰撞
  - `state-machine` — 状态机（敌人 AI、游戏状态）
  - `procedural-generation` — 程序化地牢生成
  - `godot-debugging` / `godot-optimization` / `godot-testing`

### Agent（`Agent` 工具，复杂任务委派）

- `godot-prompter:godot-game-dev` — 具体功能实现
- `godot-prompter:godot-game-architect` — 系统设计/重构
- `godot-prompter:godot-code-reviewer` — 代码审查
- 其余按需：animator / shader-author / ui-designer / tools-engineer / performance-profiler

### MCP（两个服务器，定义在全局 `~/.Codex.json`）

| 服务器 | 擅长 | 何时用 |
|---|---|---|
| `godot`（godot-mcp-pilot） | 场景/脚本增删改、运行项目、`run_gdscript` 跑片段 | 改场景结构、读写脚本、无头跑一段 GDScript 验证 |
| `godot-forge` | 静态分析、API 文档检索、跑测试、截图 | 查 Godot 4 API、分析反模式、看运行效果 |

**铁律**：写任何 Godot API 前，先 `mcp__godot-forge__godot_search_docs` 查文档——这是避免 Godot 3/4 API 混淆的最有效手段。常用搭配：`mcp__godot__run_gdscript`（无头跑片段）、`mcp__godot-forge__godot_analyze_script`（查反模式）、`mcp__godot-forge__godot_get_diagnostics`（需编辑器开着）。

## 配置说明

- MCP 服务器定义在**全局** `~/.Codex.json`（`godot` + `godot-forge`），所有 Godot 项目共享，未在本项目重复（`.mcp.json`）。
- `godot` 服务器的 `GODOT_PATH` 指向本机 `D:/Program Files (x86)/Godot_v4.7.1-stable_mono_win64/Godot_v4.7.1-stable_mono_win64.exe`（与项目 Godot 4.7 版本一致）——换机器或升级 Godot 后，用 `Codex mcp remove godot -s user` 再 `Codex mcp add godot -s user -e "GODOT_PATH=<新路径>" -- npx godot-mcp-pilot` 更新。
- 本项目权限预授权在 `.Codex/settings.local.json`（个人、不入 git）。
- `godot-prompter` 插件在**用户级** `~/.Codex/settings.json` 启用，源市场目录 `E:\File\软件包\GodotPrompter-master`。
