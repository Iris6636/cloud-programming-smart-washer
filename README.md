# 公用洗衣機智慧提醒系統｜Smart Washer Notification System

> 洗好即時知，生活更有效率！  
> Be instantly notified when laundry is done — smarter living starts here!

---

## 📘 專案簡介｜Project Introduction

宿舍洗衣機為公用資源，若有人洗完未及時取出，會造成他人等待與機台閒置。本專案旨在開發一套結合 IoT 與雲端技術的自動通知系統，提升洗衣效率與使用便利性。

Laundry machines in dormitories are shared resources. When users forget to pick up their laundry, it causes delays and inefficient usage. This project integrates IoT and cloud technologies to create an automatic notification system, improving user experience and operational efficiency.

---

## 🧱 系統架構圖｜System Architecture

![System Diagram](architecture/system_architecture.png)

本系統包含 IoT 裝置端、雲端處理端與使用者網頁端，協同完成洗衣偵測、時間辨識、狀態更新與通知推播。

The system consists of IoT devices, cloud backend, and a web frontend. Together, they detect laundry activity, recognize remaining time, update status, and notify users.

---

## 🔧 使用技術｜Tech Stack

### 🎯 AWS 雲端服務｜AWS Services
- IoT Core（設備通訊 / Device Communication）
- Lambda（邏輯處理 / Business Logic）
- DynamoDB（狀態儲存 / State Storage）
- S3（影像儲存 / Image Upload）
- Rekognition（影像文字辨識 / OCR）
- SNS（通知推播 / Notification Service）
- Cognito（使用者驗證 / Auth）
- API Gateway（前後端連接 / API Access）
- EventBridge（預約排程 / Scheduled Events）
- Lex（聊天機器人 / Chatbot）

### 📦 IoT 裝置與硬體｜IoT & Hardware
- Raspberry Pi 3 / 4
- V2 Camera 模組
- 震動感測器 SW-420
- 電磁閥 DS-0420S

### 💻 前端技術｜Frontend
- HTML / CSS / JavaScript
- S3 Static Hosting + Cognito Login

---

## 🚀 如何使用本專案｜Getting Started

### ✅ 下載專案｜Clone the Repo

```bash
git clone https://github.com/your-account/smart-washer-project.git
cd smart-washer-project
```

或下載 ZIP → 解壓縮  
Or download the ZIP and extract it.

---

### ✅ 執行 IoT 裝置程式｜Run IoT Device Code

```bash
cd iot/
python3 main.py
```

請事先連接感測器與相機，並於 `config/` 中放置 IoT 憑證與設定檔。  
Connect the sensors and camera, and ensure your AWS IoT certificates and config file are placed under `config/`.

---

### ✅ 部署 Lambda 函式｜Deploy Lambda Functions

進入 `backend/lambda_functions/`，依功能部署下列程式碼：  
Go to `backend/lambda_functions/` and deploy the following Lambda functions:

| 檔案 File | 功能 Function |
|-----------|----------------|
| `process_image.py` | 拍照上傳 + Rekognition 辨識<br>Upload image & recognize time |
| `update_status.py` | 更新洗衣狀態至 DB<br>Update washer status to DB |
| `send_notification.py` | 傳送 SNS 通知<br>Send user notification |
| `schedule_checker.py` | 檢查預約是否過期<br>Check if reservation expired |

---

### ✅ 使用網頁與聊天機器人｜Use Web & Chatbot

- `web/frontend/`：S3 上架靜態網頁，可登入與查詢機台
- `web/chatbot/`：Lex 串接 Lambda，處理自然語言查詢

- `web/frontend/`: Deployed via AWS S3 static hosting with login + status display  
- `web/chatbot/`: Handles natural language queries via Lex + Lambda

---

## 📁 專案結構｜Project Structure

```
smart-washer-project/
├── iot/                  # Raspberry Pi 裝置端程式 / IoT Device Scripts
├── backend/              # Lambda 函式與 API Gateway
├── web/                  # 前端網頁與聊天機器人
├── config/               # IoT 憑證與設定（勿上傳）
├── docs/                 # 架構圖與使用說明文件
└── README.md             # 專案說明
```

---

## 👥 團隊成員｜Team Members

雲端程式設計 第6組  
Group 6 — Cloud Programming Project  

- 吳君慧 Peggy Wu  
- 何佳穎 Chia-Ying Ho  
- 簡宏諭 Hung-Yu Chien  
- 邱子洋 Tzu-Yang Chiu

---

## 📎 注意事項｜Notes

- `config/` 資料夾請手動建立並放入憑證與設定檔。  
  請勿將 `.pem`、`.json` 等敏感檔案上傳 GitHub。  
  → Create `config/` and place certificates locally. Do NOT upload secrets to GitHub.

- 若需詳細安裝流程，請見 [`docs/setup_guide.md`](docs/setup_guide.md)  
  For detailed setup, see `docs/setup_guide.md`