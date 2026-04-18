# 公用洗衣機智慧提醒系統｜Smart Washer Notification System

> 洗好即時知，生活更有效率！
> Be instantly notified when laundry is done — smarter living starts here!

---

## 專案簡介｜Project Introduction

宿舍洗衣機為公用資源，若有人洗完未及時取出，會造成他人等待與機台閒置。本專案旨在開發一套結合 IoT 與雲端技術的自動通知系統，提升洗衣效率與使用便利性。

Laundry machines in dormitories are shared resources. When users forget to pick up their laundry, it causes delays and inefficient usage. This project integrates IoT and cloud technologies to create an automatic notification system, improving user experience and operational efficiency.

---

## 系統架構圖｜System Architecture

<!-- TODO: 加入架構圖 / Add architecture diagram -->

本系統包含三大部分：

1. **IoT 裝置端（Raspberry Pi）**：偵測洗衣機震動狀態、拍攝面板倒數畫面、控制門鎖
2. **AWS 雲端處理端**：Lambda 函式處理業務邏輯、DynamoDB 儲存狀態、Rekognition 辨識剩餘時間、SNS 推播通知
3. **使用者網頁端**：S3 靜態網站 + Cognito 登入，查詢機台狀態與操作預約

The system consists of three layers:

1. **IoT Device (Raspberry Pi)**: Detects vibration, captures washer display images, controls door lock
2. **AWS Cloud Backend**: Lambda for business logic, DynamoDB for state, Rekognition for OCR, SNS for notifications
3. **Web Frontend**: S3 static site + Cognito auth for status queries and reservations

<img width="4143" height="1851" alt="CP_team6_final_project_architecture-1" src="https://github.com/user-attachments/assets/f41cc13b-c539-4e85-aa1a-38ee4593ae09" />

---

## Demo & Presentation

如需更直觀了解本系統的實際運作流程與操作方式，可參考以下資源：
These resources provide a quick overview of the system workflow, implementation, and usage scenario.

📑 Presentation Slides: https://drive.google.com/file/d/1e8tcUKsSb5AWoy7UB3i3GPrfbrgC5sVS/view?usp=sharing
🔗 Demo Video: https://drive.google.com/file/d/1Z5XREwp7qat0I56Rl88J737r4CjiqLVn/view?usp=sharing


---

## 使用技術｜Tech Stack

### AWS 雲端服務｜AWS Services

| 服務 Service | 用途 Purpose |
|---|---|
| **IoT Core** | 設備 MQTT 通訊 / Device Communication |
| **Lambda** | 無伺服器業務邏輯 / Serverless Business Logic (17 functions) |
| **DynamoDB** | 洗衣機狀態與使用者資料儲存 / State & User Storage |
| **S3** | 影像儲存 + 靜態網站託管 / Image Storage + Static Hosting |
| **Rekognition** | 影像文字辨識洗衣剩餘時間 / OCR for Remaining Time |
| **SNS** | Email 通知推播 / Email Notifications |
| **Cognito** | 使用者驗證與授權 / Authentication & Authorization |
| **API Gateway** | REST API 前後端連接 / REST API |
| **EventBridge Scheduler** | 預約到期排程 / Scheduled Reservation Expiry |
| **Lex V2** | 中文聊天機器人 / Chinese Chatbot |
| **CloudWatch** | 監控與告警 / Monitoring & Alarms |

### IoT 裝置與硬體｜IoT & Hardware

- Raspberry Pi 3 / 4
- V2 Camera Module（拍攝洗衣機面板）
- SW-420 震動感測器（偵測洗衣機運轉）
- DS-0420S 電磁閥（門鎖控制）
- 七段顯示器（顯示倒數時間）

### 前端技術｜Frontend

- HTML / CSS / JavaScript（Vite 建置）
- S3 Static Website Hosting
- Cognito User Pool 登入驗證

---

## 專案結構｜Project Structure

```
clone_aws_washer_selfuse/
├── backend/                          # Lambda 函式原始碼
│   └── lambda_functions/             # 17 個 Python Lambda functions
├── chatbot/                          # Lex V2 聊天機器人
│   ├── AWS_lex_setting_README.md     # Lex 設定說明
│   └── WasherHelper-export.zip       # Lex V2 匯出檔（可直接匯入）
├── config/                           # IoT 憑證與設定（勿上傳 Git）
│   └── README.md                     # 憑證放置說明
├── deployment/                       # 基礎設施即程式碼 (IaC)
│   ├── infra/                        # Terraform 設定檔（terraform apply 即可部署）
│   │   ├── main.tf                   # Provider 與基本設定
│   │   ├── variables.tf              # 輸入變數（region, email）
│   │   ├── outputs.tf                # 輸出值（API URL, Cognito ID）
│   │   ├── iam.tf                    # IAM Role（Lambda + Scheduler）
│   │   ├── lambda.tf                 # Lambda 函式定義
│   │   ├── dynamodb.tf               # DynamoDB 資料表（含 Stream）
│   │   ├── sns.tf                    # SNS Topic + Email Subscription
│   │   ├── s3.tf                     # S3 Bucket（影像 + 靜態網站）
│   │   ├── cognito.tf                # Cognito User Pool + Client
│   │   ├── api_gateway.tf            # API Gateway REST API + CORS
│   │   ├── iot.tf                    # IoT Thing + Topic Rules + Policy
│   │   ├── triggers.tf               # DynamoDB Stream / S3 → Lambda 觸發器
│   │   ├── cloudwatch.tf             # CloudWatch Metric Alarm
│   │   └── terraform.tfvars.example  # 變數範本
│   ├── lambda/                       # Lambda 函式 .zip 部署包
│   ├── scripts/                      # 輔助腳本
│   │   └── package_lambdas.sh        # Lambda 打包腳本
│   └── reference/                    # 原始部署匯出紀錄（僅供參考）
│       └── generated/                # terraformer 匯出的 state snapshot
├── docs/                             # 文件
│   ├── API Gateway Setup.md          # API Gateway 設定指南
│   ├── deployment_guide.md           # 完整部署指南
│   └── iot_setup_guide.md            # IoT 裝置設定指南
├── iot/                              # Raspberry Pi IoT 裝置程式
│   └── actuator/
│       ├── main.py                   # 主控程式（MQTT + 感測器 + 相機）
│       ├── Lock_motor.py             # GPIO 馬達與門鎖控制
│       └── LED.py                    # 七段顯示器控制
├── web/                              # 前端網頁
│   └── frontend/
│       ├── index.html                # SPA 進入點
│       └── assets/                   # Vite 編譯後的 JS/CSS
├── .env.example                      # 環境變數範本
└── README.md                         # 本文件
```

---

## Lambda 函式清單｜Lambda Functions

### API 端點觸發｜API-Triggered

| 函式 Function | API 路徑 | 說明 Description |
|---|---|---|
| `team06_HandleUseRequest_NoReservation` | POST `/use` | 無預約直接使用洗衣機 / Start wash without reservation |
| `team06_HandleUseRequest_WithReservation` | POST `/use_reserved` | 有預約使用洗衣機 / Start wash with valid reservation |
| `team06_HandleReserveRequest` | POST `/reserve` | 預約洗衣機 / Reserve an available washer |
| `team06_HandleEndRequest_UnlockWasher` | POST `/unlock` | 結束洗衣並開鎖 / End wash session and unlock door |

### IoT 事件觸發｜IoT-Triggered

| 函式 Function | 說明 Description |
|---|---|
| `team06_StartWash` | 開始洗衣：鎖門、啟動拍照 / Lock door, start camera capture |
| `team06_FinishWash` | 洗衣結束：停止震動偵測 / Stop vibration detection |
| `team06_WasherHasLocked` | 門鎖回報：更新 DynamoDB 狀態 / Door locked callback |
| `team06_WasherHasUnlocked` | 開鎖回報：更新 DynamoDB 狀態 / Door unlocked callback |

### S3 / DynamoDB Stream 觸發

| 函式 Function | 觸發來源 Trigger | 說明 Description |
|---|---|---|
| `team06-RekognizeTimeAndUpdateDB` | S3 上傳事件 | Rekognition OCR 辨識剩餘時間 / Detect remaining time from image |
| `team06-SendUserLeftTimeAlert` | DynamoDB Stream | 剩餘 3 分鐘與 0 分鐘時推送通知 / Alert at 3min & 0min remaining |
| `team06_ActivateEvent` | DynamoDB Stream | 建立預約到期排程 / Create reservation expiry schedule |
| `team06_EndWashSession` | DynamoDB Stream | 洗衣結束處理，通知預約者 / Handle wash completion |

### 排程觸發｜Scheduled

| 函式 Function | 說明 Description |
|---|---|
| `team06_CheckAndReleaseWasher` | 預約 5 分鐘未使用則釋放 / Release reserved washer after 5min timeout |
| `team06_DelayedShadowUpdate` | 洗衣結束 10 秒後鎖門 / Lock door 10s after wash completion |

### 其他輔助｜Utilities

| 函式 Function | 說明 Description |
|---|---|
| `team06_V2base64toS3` | 解碼 base64 影像並上傳 S3 / Decode base64 image to S3 |
| `team06-SendReservedUserNotification` | 通知預約者洗衣機已可使用 / Notify reserved user washer is ready |

---

## 快速開始｜Getting Started

### 1. 下載專案｜Clone the Repo

```bash
git clone https://github.com/Iris6636/clone_aws_washer_selfuse.git
cd clone_aws_washer_selfuse
```

### 2. 設定 Terraform 變數｜Configure Terraform Variables

```bash
cd deployment/infra
cp terraform.tfvars.example terraform.tfvars
# 編輯 terraform.tfvars，填入你的通知 Email
```

### 3. 部署 AWS 基礎設施｜Deploy Infrastructure

使用 Terraform 部署所有 AWS 資源（IAM、Lambda、DynamoDB、S3、API Gateway、Cognito、IoT、SNS、CloudWatch）：

```bash
terraform init
terraform plan
terraform apply
```

部署完成後執行 `terraform output` 查看重要資源 ID。

完整部署指南請見 [docs/deployment_guide.md](docs/deployment_guide.md)。

### 4. 設定 IoT 裝置｜Setup IoT Device

在 Raspberry Pi 上：

```bash
cd iot/actuator/
# 將 AWS IoT 憑證放入 config/ 目錄
python3 main.py
```

詳細硬體接線與憑證設定請見 [docs/iot_setup_guide.md](docs/iot_setup_guide.md)。

### 5. 部署前端網頁｜Deploy Frontend

將 `web/frontend/` 的內容上傳至 S3 靜態網站桶：

```bash
aws s3 sync web/frontend/ s3://team06website/ --delete
```

### 6. 設定聊天機器人｜Setup Chatbot

在 AWS Lex V2 控制台匯入 `chatbot/WasherHelper-export.zip`。
詳見 [chatbot/AWS_lex_setting_README.md](chatbot/AWS_lex_setting_README.md)。

---

## API 端點｜API Endpoints

Base URL: `https://{api-id}.execute-api.us-east-1.amazonaws.com/{stage}`

所有 API 需要 Cognito User Pool Token 驗證。

| Method | Path | 說明 Description |
|--------|------|-----------------|
| POST | `/use` | 無預約使用洗衣機 / Use washer without reservation |
| POST | `/use_reserved` | 有預約使用洗衣機 / Use washer with reservation |
| POST | `/reserve` | 預約洗衣機 / Reserve a washer |
| POST | `/unlock` | 結束使用並開鎖 / End session and unlock |

Request Body 範例：
```json
{
  "user_id": "user123",
  "washer_id": 1
}
```

---

## DynamoDB 資料表｜Database Schema

### team06-WasherStatus

| 欄位 Field | 型態 Type | 說明 Description |
|---|---|---|
| `washer_id` (PK) | Number | 洗衣機編號 |
| `in_use` | Boolean | 是否使用中 |
| `reserved` | Boolean | 是否已預約 |
| `door_locked` | Boolean | 門鎖狀態 |
| `vibration` | Boolean | 震動偵測狀態 |
| `time` | Number | 剩餘分鐘數（Rekognition OCR） |
| `expire_at` | Number | 預約到期時間戳 |

### team06-UserInfo

| 欄位 Field | 型態 Type | 說明 Description |
|---|---|---|
| `user_id` (PK) | String | 使用者 ID |
| `email` | String | 通知用 Email |
| `in_use` | Number | 正在使用的 washer_id |
| `reserved` | Number | 已預約的 washer_id |

---

## 團隊成員｜Team Members

雲端程式設計 第6組｜Group 6 — Cloud Programming Project

- 吳君慧 Peggy Wu
- 何佳穎 Chia-Ying Ho
- 簡宏諭 Hung-Yu Chien
- 邱子洋 Tzu-Yang Chiu

---

## 相關文件｜Documentation

| 文件 Document | 說明 Description |
|---|---|
| [docs/deployment_guide.md](docs/deployment_guide.md) | 完整 Terraform 部署指南 |
| [docs/iot_setup_guide.md](docs/iot_setup_guide.md) | IoT 裝置硬體與憑證設定 |
| [docs/API Gateway Setup.md](docs/API%20Gateway%20Setup.md) | API Gateway 設定步驟 |
| [chatbot/AWS_lex_setting_README.md](chatbot/AWS_lex_setting_README.md) | Lex V2 聊天機器人設定 |

---

## 注意事項｜Notes

- `config/` 資料夾內含 IoT 憑證，**請勿上傳至 GitHub**。
  詳見 [config/README.md](config/README.md) 了解需要哪些憑證檔案。

- 所有 Lambda 函式使用 **Python 3.9** runtime。

- 部署前請確認 AWS CLI 已設定正確的 credentials 與 region (`us-east-1`)。
