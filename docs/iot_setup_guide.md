# IoT 裝置設定指南｜IoT Device Setup Guide

本文件說明如何設定 Raspberry Pi IoT 裝置，包含硬體接線、AWS IoT 憑證設定與軟體執行。

This guide covers Raspberry Pi hardware wiring, AWS IoT certificate setup, and running the device software.

---

## 硬體需求｜Hardware Requirements

| 元件 Component | 型號 Model | 用途 Purpose |
|---|---|---|
| 主板 | Raspberry Pi 3 / 4 | 主控制器 |
| 相機 | V2 Camera Module | 拍攝洗衣機面板倒數畫面 |
| 震動感測器 | SW-420 | 偵測洗衣機是否運轉 |
| 電磁閥 | DS-0420S | 門鎖控制 |
| 顯示器 | 七段顯示器（共陰極） | 顯示剩餘時間 |

---

## GPIO 接線圖｜GPIO Wiring

### 七段顯示器（十位數）｜7-Segment Display (Tens Digit)

| GPIO Pin | 顯示器段 Segment |
|----------|-----------------|
| GPIO 1 | Segment A |
| GPIO 2 | Segment B |
| GPIO 3 | Segment C |
| GPIO 4 | Segment D |
| GPIO 5 | Segment E |
| GPIO 6 | Segment F |
| GPIO 7 | Segment G |

### 七段顯示器（個位數）｜7-Segment Display (Units Digit)

| GPIO Pin | 顯示器段 Segment |
|----------|-----------------|
| GPIO 8 | Segment A |
| GPIO 9 | Segment B |
| GPIO 10 | Segment C |
| GPIO 11 | Segment D |
| GPIO 12 | Segment E |
| GPIO 13 | Segment F |
| GPIO 14 | Segment G |

### 控制元件｜Control Components

| GPIO Pin | 元件 Component | 方向 Direction |
|----------|---------------|---------------|
| GPIO 15 | 電磁閥 / Door Lock (DS-0420S) | OUTPUT |
| GPIO 16 | 馬達 / Motor | OUTPUT |
| GPIO 17 | 震動感測器 / Vibration Sensor (SW-420) | INPUT |

---

## AWS IoT 憑證設定｜AWS IoT Certificate Setup

> **注意：** IoT Thing（`team06_IoT`）和 IoT Policy（`team06-iot-policy`）已由 `terraform apply` 自動建立。
> 你只需要在 AWS Console 手動建立 Certificate 並與 Thing 綁定。

### Step 1: 建立 Certificate 並下載憑證

1. 登入 [AWS IoT Console](https://console.aws.amazon.com/iot/)
2. 確認 region 為 **us-east-1**
3. 前往 **Security → Certificates**
4. 點擊 **Create certificate** → **Auto-generate certificate**
5. 下載以下三個檔案（**只有這次機會下載，請立刻儲存**）：
   - `AmazonRootCA1.pem`（Root CA）
   - `xxxxxxxx-certificate.pem.crt`（Device Certificate）
   - `xxxxxxxx-private.pem.key`（Private Key）
6. 點擊 **Activate** 啟用憑證

### Step 2: 附加 Policy 與 Thing

在剛建立的 Certificate 頁面：

1. **Actions → Attach policy** → 選擇 `team06-iot-policy`
2. **Actions → Attach thing** → 選擇 `team06_IoT`

### Step 3: 放置憑證檔案

將下載的憑證檔案重新命名並放入專案的 `config/` 目錄：

```
config/
├── AmazonRootCA1_RSA.pem      # Root CA 憑證
├── certificate.pem             # 裝置憑證
└── private.pem.key             # 私鑰
```

```bash
# 在專案根目錄執行
mkdir -p config
cp ~/Downloads/AmazonRootCA1.pem config/AmazonRootCA1_RSA.pem
cp ~/Downloads/xxxxxxxx-certificate.pem.crt config/certificate.pem
cp ~/Downloads/xxxxxxxx-private.pem.key config/private.pem.key
```

### Step 4: 確認 IoT Endpoint

```bash
aws iot describe-endpoint --endpoint-type iot:Data-ATS --region us-east-1
```

記下輸出的 `endpointAddress`，格式如：
```
xxxxxxxxxx-ats.iot.us-east-1.amazonaws.com
```

### Step 5: 更新程式設定

編輯 `iot/actuator/main.py`，確認以下設定與你的環境一致：

```python
# IoT Endpoint（替換為你的 endpoint）
ENDPOINT = "your-endpoint-ats.iot.us-east-1.amazonaws.com"

# Thing Name
THING_NAME = "team06_IoT"

# 憑證路徑（指向 config/ 目錄）
ROOT_CA = "../../config/AmazonRootCA1_RSA.pem"
CERT = "../../config/certificate.pem"
KEY = "../../config/private.pem.key"
```

---

## 軟體安裝｜Software Installation

### Raspberry Pi OS 設定

```bash
# 啟用 Camera
sudo raspi-config
# → Interface Options → Camera → Enable

# 啟用 GPIO
sudo raspi-config
# → Interface Options → GPIO → Enable
```

### 安裝 Python 套件

```bash
pip3 install awsiotsdk
pip3 install picamera2
pip3 install RPi.GPIO
```

### 相依套件清單｜Dependencies

| 套件 Package | 用途 Purpose |
|---|---|
| `awscrt` | AWS IoT SDK C Runtime |
| `awsiot` | AWS IoT Device SDK |
| `picamera2` | Raspberry Pi Camera V2 控制 |
| `RPi.GPIO` | GPIO 腳位控制 |

---

## 執行裝置程式｜Run Device Software

```bash
cd iot/actuator/
python3 main.py
```

### 預期行為

程式啟動後會：

1. 連線至 AWS IoT Core（MQTT over TLS, port 8883）
2. 訂閱 Device Shadow delta topic
3. 監聽震動感測器（GPIO 17）
4. 等待雲端指令（開鎖/鎖門/拍照）

### 運作流程

```
震動偵測 → 回報 vibration_detected=true → 雲端觸發 StartWash
     ↓
雲端設定 capture_requested=true → 每 2.5 秒拍照上傳至 S3
     ↓
Rekognition OCR 辨識剩餘時間 → 更新 DynamoDB
     ↓
時間到 → SNS 通知使用者 → 雲端設定 door_locked=false → 開鎖
```

---

## Device Shadow 互動｜Device Shadow Interaction

### Reported State（裝置回報）

| 欄位 Field | 型態 Type | 說明 Description |
|---|---|---|
| `washer_id` | Number | 洗衣機編號 |
| `vibration_detected` | Boolean | 是否偵測到震動 |
| `door_locked` | Boolean | 門鎖狀態 |
| `capture_requested` | Boolean | 是否正在拍照 |
| `unlock_reason` | String | 開鎖原因 |

### Desired State（雲端控制）

| 欄位 Field | 觸發行為 Action |
|---|---|
| `door_locked: true` | 裝置鎖門 |
| `door_locked: false` | 裝置開門 |
| `capture_requested: true` | 開始定時拍照（每 2.5 秒） |
| `capture_requested: false` | 停止拍照 |
| `unlock_reason` | 記錄開鎖原因 |

---

## 除錯｜Troubleshooting

### 連線失敗

- 確認憑證檔案路徑正確
- 確認 IoT Endpoint 正確
- 確認 IoT Policy 已附加到 Certificate
- 確認 Raspberry Pi 可以連上網路

### 拍照失敗

- 確認 Camera Module 已正確連接
- 確認已在 raspi-config 啟用 Camera
- 測試：`libcamera-hello` 或 `raspistill -o test.jpg`

### GPIO 無反應

- 確認接線正確對應 GPIO pin number（非 physical pin number）
- 確認已安裝 `RPi.GPIO` 套件
- 確認以 root 或有 GPIO 權限的使用者執行
