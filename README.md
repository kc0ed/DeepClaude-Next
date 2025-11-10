<div>
<h1>DeepClaude 🐬🧠 - OpenAI Compatible（deepclaude & deepgemini）</h1>

<a href="https://github.com/getasterisk/deepclaude"> Inspiration from getasterisk/deepclaude</a>

[![GitHub license](https://img.erlich.fun/personal-blog/uPic/deepclaude.svg)](#)
[![Compatible with](https://img.erlich.fun/personal-blog/uPic/-ChatGPT-412991.jpg)](https://openai.com)

</div>


<details>
<summary><strong>更新日志：</strong></summary> 
2025-05-29.2：更新 Docker Image 运行平台支持，可以通过 `docker pull erlichliu/deepclaude ` 拉取到本地运行，自动选择合适的平台版本。

2025-05-29.1：feat: 系统配置添加 deepseek r1 的 max_tokens 设置，降低成本。


2025-05-27.2: 支持配置文件的导入导出模式，方便升级或部署后反复进行配置。

2025-05-27.1: 适配 Gemini API 流式响应上的结束标记处理顺序问题。

2025-05-22.3: 优化 openai 兼容格式返回结束标志，改善近期 deepgeminipro 中断回复的问题。

2025-05-22.2: 优化组合模型之间的衔接 Prompt，提高不同模型本身的能力表达。

2025-05-22.1: 支持可关闭 gemini 2.5 flash 的思考，节省 tokens 消耗，针对 gemini 2.5 pro 采用提示词优化的方式也可以平均每次降低 30% 的成本消耗。

2025-05-16.1: 支持更友好的多段落报错返回，尤其是针对超过上下文长度的报错返回，可以更好的适配前端界面的报错。

2025-03-22.1: 支持根据不同模型设置是否开启代理，提高运行效率。

2025-03-10.1: deepseek r1 推理部分 max_token 改为 5，节省输出 Tokens 消耗；非流式输出部分增加 reasoning_content 数据字段的返回；将非流式输出设置为缺省值，方便 dify 等工具使用。

2025-03-05.1: 更改docker compose配置, 使用volume将容器配置文件绑定至本地, 避免重启容器时丢失配置. 同时设置失败自动重启.

2025-03-02.1: 更新 1.0 版本，支持图形化配置界面，取消 .env 配置，预配置模板，配置更方便

2025-02-25.1: 添加 system message 对于 Claude 3.5 Sonnet 的支持

2025-02-23.1: 重构代码，支持 OpenAI 兼容模型，deepgeminiflash 和 deepgeminipro 配置更方便（请详细查看 READEME 和 .env.example 内的说明）。

2025-02-21.1: 添加 Claude 这段的详细数据结构安全检查。

2025-02-16.1: 支持 claude 侧采用请求体中的自定义模型名称。（如果你采用 oneapi 等中转方，那么现在可以通过配置环境变量或在 API 请求中采用任何 Gemini 等模型完成后半部分。接下来将重构代码，更清晰地支持不同的思考模型组合。）

2025-02-08.2: 支持非流式请求，支持 OpenAI 兼容的 models 接口返回。（⚠️ 当前暂未实现正确的 tokens 消耗统计，稍后更新）

2025-02-08.1: 添加 Github Actions，支持 fork 自动同步、支持自动构建 Docker 最新镜像、支持 docker-compose 部署

2025-02-07.2: 修复 Claude temperature 参数可能会超过范围导致的请求失败的 bug

2025-02-07.1: 支持 Claude temputerature 等参数；添加更详细的 .env.example 说明

2025-02-06.1：修复非原生推理模型无法获得到推理内容的 bug

2025-02-05.1: 支持通过环境变量配置是否是原生支持推理字段的模型，满血版本通常支持

2025-02-04.2: 支持跨域配置，可在 .env 中配置

2025-02-04.1: 支持 Openrouter 以及 OneAPI 等中转服务商作为 Claude 部分的供应商

2025-02-03.3: 支持 OpenRouter 作为 Claude 的供应商，详见 .env.example 说明

2025-02-03.2: 由于 deepseek r1 在某种程度上已经开启了一个规范，所以我们也遵循推理标注的这种规范，更好适配支持的更好的 Cherry Studio 等软件。

2025-02-03.1: Siliconflow 的 DeepSeek R1 返回结构变更，支持新的返回结构

</div>
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