<div>
<h1>DeepClaude-Next 🐬🧠 - An Enhanced OpenAI Compatible Gateway</h1>

> 本项目基于 <a href="https://github.com/ErlichLiu/DeepClaude">ErlichLiu/DeepClaude</a> 的源代码进行二次开发和维护，旨在提供更纯粹、更强大的社区驱动版本。

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](#)
[![Compatible with](https://img.shields.io/badge/Compatible%20with-OpenAI-brightgreen.svg)](https://openai.com)

</div>

<details>
<summary><strong>更新日志 (DeepClaude-Next)</strong></summary>
<ul>
    <li><strong>2025-11-10:</strong>
        <ul>
            <li>feat: 添加 Windows 快速启动脚本 (<code>start_windows.bat</code>)。</li>
            <li>docs: 修正克隆地址和 Docker 部署说明，使其与本仓库保持一致。</li>
            <li>refactor: 移除所有原始项目中的推广、赞助和个人信息内容。</li>
            <li>feat(docs): 添加详细的项目架构指南 (<code>整体架构.md</code>)。</li>
            <li>refactor(frontend): 对配置页面进行全面的用户体验优化，包括：
                <ul>
                    <li>统一并简化保存逻辑。</li>
                    <li>引入“自动保存”与未保存状态提示。</li>
                    <li>增加全局加载状态，防止异步操作时的用户误触。</li>
                    <li>优化模型的增删改渲染，提升流畅度。</li>
                    <li>增强导入预览功能，提供清晰的差异比对视图。</li>
                </ul>
            </li>
        </ul>
    </li>
</ul>
</details>

# 简介
最近 DeepSeek 推出了 [DeepSeek R1 模型](https://platform.deepseek.com)，在推理能力上已经达到了第一梯队。但是 DeepSeek R1 在一些日常任务的输出上可能仍然无法匹敌 Claude 3.5 Sonnet。Aider 团队最近有一篇研究，表示通过[采用 DeepSeek R1 + Claude 3.5 Sonnet 可以实现最好的效果](https://aider.chat/2025/01/24/r1-sonnet.html)。

<img src="https://img.erlich.fun/personal-blog/uPic/heiQYX.png" alt="deepseek r1 and sonnet benchmark" style="width=400px;"/>

> **R1 as architect with Sonnet as editor has set a new SOTA of 64.0%** on the [aider polyglot benchmark](https://aider.chat/2024/12/21/polyglot.html). They achieve this at **14X less cost** compared to the previous o1 SOTA result.

本项目受到该项目的启发，通过 fastAPI 完全重写，经过 15 天大量社区用户的真实测试，我们创作了一些新的组合使用方案。

**1.编程：推荐使用 deepclaude = deepseek r1 + claude 3.7 sonnet;
2.内容创作：推荐使用 deepgeminipro = deepseek r1 + gemini 2.0 pro (该方案可以完全免费使用);
3.日常实验：推荐 deepgeminiflash = deepseek r1 + gemini 2.0 flash (该方案可以完全免费使用)。**

项目**支持 OpenAI 兼容格式的输入输出**，支持 DeepSeek 官方 API 以及第三方托管的 API、生成部分也支持 Claude 官方 API 以及中转 API，并对 OpenAI 兼容格式的其他 Model 做了特别支持。

**🔥推荐使用方法：**
1.用户可以自行运行在自己的服务器，并对外提供开放 API 接口，接入 [OneAPI](https://github.com/songquanpeng/one-api) 等实现统一分发。

2.接入你的日常大语言模型对话聊天使用。

# Implementation

![image-20250201212456050](https://img.erlich.fun/personal-blog/uPic/image-20250201212456050.png)

# How to run

> 项目支持本地运行和 Docker 部署。



## 2. 本地开发 (不使用 Docker)

如果您希望在本地直接运行项目以进行开发和调试，请遵循以下步骤。

**环境准备**:

1.  **Python**: 确保您已安装 Python 3.11 或更高版本。
2.  **uv**: 项目使用 `uv` 作为包管理器。如果尚未安装，请先运行 `pip install uv`。

**启动步骤**:

1.  **克隆项目** (如果您尚未操作):
    ```bash
    git clone https://github.com/kc0ed/DeepClaude-Next.git
    cd DeepClaude-Next
    ```

2.  **创建并激活虚拟环境**:
    使用 `uv` 创建一个独立的虚拟环境。
    ```bash
    uv venv
    ```
    然后激活它：
    *   Windows (CMD): `.venv\Scripts\activate`
    *   Windows (PowerShell): `.venv\Scripts\Activate.ps1`
    *   macOS/Linux: `source .venv/bin/activate`

3.  **安装依赖**:
    在激活的虚拟环境中，使用 `uv` 安装所有项目依赖。
    ```bash
    uv pip install .
    ```

4.  **启动应用**:
    使用 `uvicorn` 启动 FastAPI 服务，并开启热重载。
    ```bash
    uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
    ```

5.  **访问配置页面**:
    启动成功后，在浏览器中打开 `http://localhost:8000/config` 即可开始配置。

> **🚀 快速启动 (Windows 用户)**:
> 为了方便 Windows 用户，项目根目录下提供了一个 `start_windows.bat` 脚本。您只需双击运行它，即可自动完成虚拟环境创建、依赖安装、启动服务和打开浏览器等所有步骤。

---

## 3. 部署运行 (使用 Docker)

✅ Step 1. 安装 Docker

请确保你已经安装了 Docker Desktop（适用于 macOS 和 Windows），或 Docker Engine（适用于 Linux）。

Windows 下载安装地址：https://docs.docker.com/desktop/setup/install/windows-install/
macOS 下载安装地址：https://docs.docker.com/desktop/setup/install/mac-install/

安装完成后，确保在终端中运行以下命令没有报错：

`docker --version`

🚀 Step 2. 构建并运行项目

```bash
# 1. 克隆您的项目仓库
git clone https://github.com/kc0ed/DeepClaude-Next.git

# 2. 进入项目目录
cd DeepClaude-Next

# 3. 使用项目中的 Dockerfile 构建本地镜像
# 您可以将 deepclaude-next:latest 替换为您喜欢的任何名称和标签
docker build -t deepclaude-next:latest .

# 4. 运行您刚刚构建的镜像
docker run -p 8000:8000 deepclaude-next:latest
```

⸻

📦 可选：后台运行 + 自动重启（建议部署时使用）

```bash
docker run -d --restart unless-stopped -p 8000:8000 deepclaude-next:latest
```

⸻

Step 4. 开始配置：打开浏览器访问 http://localhost:8000/config 输入默认 api key：123456 （如果你运行在云端，请尽快登录后在系统设置内更改，避免被其他人盗用，本地登录则无需更改）
![配置授权页面](https://img.erlich.fun/personal-blog/uPic/HW7YfK.png)

按照提示在“推理模型这一栏”配置一个火山云引擎的 api key，点击编辑，粘贴进去 api key 后点击保存即可
![配置火山云引擎的 api key](https://img.erlich.fun/personal-blog/uPic/PNfOcU.png)

`是否支持原生推理`选项控制了两套针对推理模型返回思考内容.

- 支持原生推理: 推理模型在返回体`reasoning_content`字段返回推理内容, 在`content`字段返回回答内容. 例如:
  - DeepSeek官方 `deepseek-reasoner`
  - Siliconflow `deepseek-ai/deepseek-r1`
- 不支持原生推理: 推理模型在`content`字段中以`<think></think>`标签包裹推理内容返回. 例如:
  - 派欧算力云 `deepseek/deepseek-r1`, `deepseek/deepseek-r1/community`, `deepseek/deepseek-r1-turbo`
  - AiHubMix `aihubmix-DeepSeek-R1`
  - Cluade 3.7 Sonnet Thinking

大多数服务商提供的deepseek-r1均支持原生推理, 所以推荐默认开启. 如果不确定可以在外部使用聊天框架(Chatbox)测试模型响应内容. 如果出现`<think></think>`标签则需要关闭`支持原生推理`选项.

不支持原生推理的deepseek-r1可能需要prompt来触发思考, 若日志中收集到推理内容长度一直为0, 而且出现`<think>`字样, 则考虑检查此因素:

![image](https://img.erlich.fun/personal-blog/uPic/63bf0a9f-19cf-49d4-aa28-e916b2a62138.png)


按照提示在“目标模型”配置一个 Claude 3.7 Sonnet 的 api key 以及一个 Gmeini 的 api key，Gemini 的 api key 可以在：https://aistudio.google.com/apikey 获取
![配置 Claude 3.7 Sonnet 的 api key](https://img.erlich.fun/personal-blog/uPic/ydKSHW.png)
同理，也可以配置一个 Gemini 的 api key 分别到 deepgeminiflash 和 deepgeminipro
![配置 Gemini api key](https://img.erlich.fun/personal-blog/uPic/XGXDkz.png)

Step 5. 配置程序到你的 Chatbox（推荐 [Cherry Studio](https://cherry-ai.com) [NextChat](https://nextchat.dev/)、[ChatBox](https://chatboxai.app/zh)、[LobeChat](https://lobechat.com/)）

**如果你的客户端是 Cherry Studio、Chatbox（选择 OpenAI API 模式，注意不是 OpenAI 兼容模式）**
API 地址为 http://127.0.0.1:8000
API 密钥为默认的 123456，如果你在系统设置内进行修改，则改为你修改过的即可
需要手动配置三个模型，分别为 deepclaude、deepgeminiflash 和 deepgeminipro 模型

**如果你的客户端是 LobeChat**
API 地址为：http://127.0.0.1:8000/v1
API 密钥为默认的 123456，如果你在系统设置内进行修改，则改为你修改过的即可
支持获取模型列表，可以同时获取到 deepclaude、deepgeminiflash 和 deepgeminipro 模型


**注：本项目采用 uv 作为包管理器，这是一个更快速更现代的管理方式，用于替代 pip，你可以[在此了解更多](https://docs.astral.sh/uv/)**

# Technology Stack
- [FastAPI](https://fastapi.tiangolo.com/)
- [UV as package manager](https://docs.astral.sh/uv/#project-management)
- [Docker](https://www.docker.com/)