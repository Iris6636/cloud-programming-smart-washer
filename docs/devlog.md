# 專案開發日誌

## 2026/04/03

### 一、完整驗證完成

#### API 端點
| 項目 | 結果 |
|------|------|
| GET /scan | ✅ |
| GET /washer/:id | ✅ |
| GET /user/:id | ✅ |
| POST /use（無預約） | ✅ |
| POST /use_reserved（有預約） | ✅ |
| POST /reserve | ✅ |
| POST /unlock | ✅ |

#### IoT Topic Rules（Shadow 模擬）
| 項目 | 結果 |
|------|------|
| StartWash（vibration false→true） | ✅ |
| FinishWash（vibration true→false） | ✅ |
| LockWasher（door_locked false→true） | ✅ |
| EndWash_Unlock（door_locked true→false, unlock_reason=end_wash） | ✅ |
| Reserved_Unlock（door_locked true→false, unlock_reason=reserve_related） | ✅ |
| CaptureImageToS3（MQTT device/camera/image） | ✅ |

#### 通知與資料
| 項目 | 結果 |
|------|------|
| SNS 預約通知（SendReservedUserNotification） | ✅ |
| SNS 剩餘時間警告 3 分鐘（SendUserLeftTimeAlert） | ✅ |
| SNS 剩餘時間警告 0 分鐘（SendUserLeftTimeAlert） | ✅ |
| S3 上傳 + Rekognition 辨識 → DynamoDB time 更新 | ✅ |
| CloudWatch Alarm（Rekognition 失敗自動觸發 SNS） | ✅ |

#### 修復紀錄
| 問題 | 修復方式 |
|------|---------|
| `team06_V2base64toS3.zip` 裡的檔名是 `lambda_function.py`，handler 找不到模組 | 重新打包，改名為 `team06_V2base64toS3.py` |
| `team06_V2base64toS3` Lambda 沒有 `source_code_hash`，Terraform 無法偵測 zip 變更 | 加上 `source_code_hash = filebase64sha256(...)` |
| Lambda role 缺少 `s3:ListBucket`，導致 S3 PutObject 回傳 `NoSuchBucket` | 在 `iam.tf` 加上 `s3:ListBucket` |
| CloudWatch Alarm 從未觸發（no datapoints）：terraformer 未匯出 CloudWatch Logs Metric Filter | 在 `cloudwatch.tf` 補上 `aws_cloudwatch_log_metric_filter`，監聽 `[REKOGNITION_FAIL]` log pattern |

#### IoT Shadow 模擬指令（Windows PowerShell）
```powershell
# ⚠️ 每次開始前先取 token（有效期 1 小時）
$body = @{
    AuthFlow = "USER_PASSWORD_AUTH"
    ClientId = "5i4fptbg1c1fqrm2vlq1rrvo07"
    AuthParameters = @{ USERNAME = "thpss93214@gmail.com"; PASSWORD = "TempPass123!" }
} | ConvertTo-Json
$resp = Invoke-RestMethod -Uri "https://cognito-idp.us-east-1.amazonaws.com/" `
    -Method POST `
    -Headers @{ "X-Amz-Target" = "AWSCognitoIdentityProviderService.InitiateAuth"; "Content-Type" = "application/x-amz-json-1.1" } `
    -Body $body
$token = $resp.AuthenticationResult.IdToken

# Shadow 更新（避免 BOM 問題用 WriteAllText）
[System.IO.File]::WriteAllText("$PWD\payload.json", '{"state":{"reported":{...}}}')
aws iot-data update-thing-shadow --region us-east-1 --thing-name team06_IoT --payload fileb://payload.json output.json
```

---

## 2026/03/29

### 一、IoT 模擬驗證（進行中）

#### 已完成
- [x] StartWash — IoT Shadow vibration false → true，DynamoDB `vibration: true` 寫入 ✅
- [ ] FinishWash — 進行中，token 過期中斷
- [ ] LockWasher
- [ ] EndWash_Unlock
- [ ] Reserved_Unlock
- [ ] CaptureImageToS3

#### 剩餘 API 驗證
- [ ] POST /use_reserved
- [ ] SendUserLeftTimeAlert SNS 通知

#### 已知問題
- **CloudWatch Alarm 已修復**：根因是 terraformer 未匯出 CloudWatch Logs Metric Filter，補上後 Alarm 正常觸發。觸發鏈：空白圖片 → Rekognition 辨識失敗 → Lambda 寫入 `[REKOGNITION_FAIL]` log → Metric Filter 轉為計數 → Alarm 觸發 → SNS 寄信。

#### ⚠️ 每次開始前必須先取 token（有效期 1 小時）
```powershell
$body = @{
    AuthFlow = "USER_PASSWORD_AUTH"
    ClientId = "5i4fptbg1c1fqrm2vlq1rrvo07"
    AuthParameters = @{
        USERNAME = "thpss93214@gmail.com"
        PASSWORD = "TempPass123!"
    }
} | ConvertTo-Json

$resp = Invoke-RestMethod -Uri "https://cognito-idp.us-east-1.amazonaws.com/" `
    -Method POST `
    -Headers @{ "X-Amz-Target" = "AWSCognitoIdentityProviderService.InitiateAuth"; "Content-Type" = "application/x-amz-json-1.1" } `
    -Body $body

$token = $resp.AuthenticationResult.IdToken
Write-Host "Token OK"
```

#### IoT Shadow 模擬方式（Windows PowerShell）
```powershell
# 正確寫法：用 [System.IO.File]::WriteAllText 避免 BOM 問題
[System.IO.File]::WriteAllText("$PWD\payload.json", '{"state":{"reported":{...}}}')
aws iot-data update-thing-shadow --region us-east-1 --thing-name team06_IoT --payload fileb://payload.json output.json
```

#### 作品集待辦
- [ ] 補架構圖（README 有 TODO 佔位符）
- [ ] docs/verification_guide.md（整理所有驗證指令）

---

## 2026/03/28

### 一、API 驗證完成

接續 2025/02/28 的工作，完成所有 API 端點與核心功能驗證。

---

## 2025/02/28

### 一、專案概覽

- 專案名稱：clone_aws_washer_selfuse（智慧洗衣機 AWS 雲端系統）
- 原始來源：team06 課堂專案，從原本 AWS 帳號匯出後重新部署到自己的 AWS 帳號
- 架構：前端 S3 靜態網站 + API Gateway + Lambda + DynamoDB + Cognito + IoT Core + S3 + SNS + Rekognition + CloudWatch

---

### 二、專案結構確認

```
clone_aws_washer_selfuse/
├── backend/lambda_functions/   ← 18 個 Python Lambda 原始碼（.py）
├── deployment/
│   ├── infra/                  ← Terraform IaC（主要部署用）
│   ├── lambda/                 ← 20 個 Lambda zip 打包檔（給 TF 部署）
│   └── reference/generated/    ← terraformer import 匯出的參考快照（不部署）
├── web/                        ← 前端靜態網頁
├── iot/                        ← IoT 相關程式碼
├── chatbot/                    ← Lex chatbot（本次未部署）
├── config/                     ← 設定檔
└── docs/                       ← 文件
```

#### 關鍵發現

- `backend/lambda_functions/*.py` 是原始碼，`deployment/lambda/*.zip` 是打包後的部署檔案，兩邊對應
- Terraform 的 `aws_lambda_function` 只能吃 `.zip`（或 container image）
- `deployment/reference/` 裡面幾乎全是 team06 的東西，只有 API Gateway stage 裡有一行 TEAM18（因為原本 AWS 帳號是共用的）
- **Terraform 只有部署 team06 的資源，沒有其他 team**

---

### 三、已完成的工作

#### 1. Sign Up / Login 驗證 ✅

- Cognito User Pool 部署成功
- 前端可以正常註冊、登入
- JWT token 正常取得

#### 2. Express Lambda 502 修復 ✅

- **問題**：API Gateway 呼叫 express Lambda 回傳 502 Bad Gateway
- **根因**：express.zip 裡的程式碼有問題（路由/CORS 設定）
- **修復**：重新打包 express.zip，修正路由和 CORS 設定
- **結果**：API 呼叫恢復正常

---

### 四、決定事項

| 項目 | 決定 | 原因 |
|------|------|------|
| Chatbot (Lex) | 不部署 | 本次不需要，跳過 |
| 其他 team 的資源 | 不管 | reference 目錄裡的參考資料，不影響部署 |
| Lambda zip vs py | 維持兩邊放 | backend/ 放原始碼方便編輯，deployment/lambda/ 放 zip 給 TF 部署 |
| Terraform runtime | Python 3.13 + Node.js 22.x | 原本的 runtime 版本，沿用 |

---

### 五、待驗證項目

- [x] **洗衣機狀態查詢** — GET /scan、GET /washer/:id ✅
- [x] **使用洗衣機** — POST /use（無預約）✅
- [x] **預約洗衣機** — POST /reserve ✅
- [x] **解鎖洗衣機** — POST /unlock ✅（DynamoDB REMOVE in_use + IoT Shadow 指令送出）
- [x] **SNS email 通知** — thpss93214@gmail.com 收到通知 ✅（需帶 MessageAttribute: user_email_address）
- [x] **S3 + Rekognition** — 上傳測試圖 → Lambda 觸發 → time: 30 寫入 DynamoDB ✅
- [x] **DynamoDB 資料寫入** — 各操作均確認寫入正確 ✅
- [x] **CloudWatch Alarm** — 上傳空白圖片觸發 Rekognition 失敗 → Metric Filter 偵測 `[REKOGNITION_FAIL]` log → Alarm 自動發送 SNS email ✅

#### 備註

- SNS FilterPolicy 有設定 `user_email_address`，publish 時必須帶對應 MessageAttribute 才能收到
- Express API (`qqjutw326e`) 負責 GET（/scan、/washer/:id、/user/:id）
- IoT API (`povc5px4j8`) 負責 POST（/use、/reserve、/unlock）
- 兩組 API 都需要 Cognito JWT token（Authorization: Bearer \<token\>）

---

### 六、Lambda 函數清單（共 20 個）

| # | 函數名稱 | Runtime | 用途 |
|---|----------|---------|------|
| 1 | team06-RekognizeTimeAndUpdateDB | Python 3.13 | Rekognition 辨識時間並更新 DB |
| 2 | team06-SendReservedUserNotification | Python 3.13 | 發送預約通知（SNS） |
| 3 | team06-SendUserLeftTimeAlert | Python 3.13 | 發送剩餘時間警告（SNS） |
| 4 | team06_ActivateEvent | Python 3.13 | 啟動排程事件 |
| 5 | team06_CheckAndReleaseWasher | Python 3.13 | 檢查並釋放洗衣機 |
| 6 | team06_DelayedShadowUpdate | Python 3.13 | 延遲更新 IoT Shadow |
| 7 | team06_EndWashSession | Python 3.13 | 結束洗衣 session |
| 8 | team06_FinishWash | Python 3.13 | 完成洗衣 |
| 9 | team06_HandleEndRequest_UnlockWasher | Python 3.13 | 處理結束請求、解鎖 |
| 10 | team06_HandleReserveRequest | Python 3.13 | 處理預約請求 |
| 11 | team06_HandleUseRequest_NoReservation | Python 3.13 | 處理使用請求（無預約） |
| 12 | team06_HandleUseRequest_WithReservation | Python 3.13 | 處理使用請求（有預約） |
| 13 | team06_StartWash | Python 3.13 | 開始洗衣 |
| 14 | team06_WasherHasLocked | Python 3.13 | 洗衣機已鎖定 |
| 15 | team06_WasherHasUnlocked | Python 3.13 | 洗衣機已解鎖 |
| 16 | team06_V2base64toS3 | Python 3.13 | Base64 圖片上傳到 S3 |
| 17 | team06_upload | Python 3.13 | 上傳功能 |
| 18 | team06_CloudWatch_Alarm_Rekognition_Fail | Python 3.11 | Rekognition 失敗告警 |
| 19 | team06-express | Node.js 22.x | 主要 API server（已修復） |

---

### 七、備註

- 原始 AWS 帳號 ID：701030859948（reference 裡的，不是我們的）
- 部署用的 Terraform 在 `deployment/infra/`
- `deployment/reference/` 只是參考用，用 terraformer import 匯出的，不要拿來直接部署
