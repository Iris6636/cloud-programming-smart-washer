# 部署指南｜Deployment Guide

本文件說明如何使用 Terraform 從零部署整個 Smart Washer Notification System 的 AWS 基礎設施。

This guide walks you through deploying the full AWS infrastructure for the Smart Washer Notification System using Terraform.

---

## 部署總覽｜Deployment Checklist

**從 clone 到系統完整運作，共需完成以下步驟（依序執行）：**

| 步驟 | 動作 | 備註 |
|------|------|------|
| 前置準備 | 安裝 AWS CLI、Terraform，設定 AWS 帳號 | 只需做一次 |
| Step 1 | 設定 Terraform 變數 | 填入 Email、S3 bucket 名稱 |
| Step 2 | terraform init | 下載 AWS Provider |
| Step 3 | terraform plan | 確認將建立的資源 |
| Step 4 | terraform apply | 建立所有 AWS 資源 |
| Step 5 | 記錄 Terraform 輸出值 | API URL、Cognito ID 等後續會用到 |
| Step 6 | 確認 SNS 訂閱信 | **必做**，否則通知永遠不會送達 |
| Step 7 | 初始化 DynamoDB 資料 | **必做**，否則 /scan 沒有洗衣機資料 |
| Step 8 | 建立 Cognito 使用者 | 設定登入帳號與永久密碼 |
| Step 9 | 部署前端網頁 | 執行 deploy_frontend.sh 上傳至 S3 |
| Step 10 | 設定 IoT 裝置憑證 | 在 AWS Console 建立憑證並下載到 Pi |
| Step 11 | 啟動 Raspberry Pi 程式 | 執行 iot/actuator/main.py |

> **Raspberry Pi 相關的步驟（10-11）詳細說明請見 [`docs/iot_setup_guide.md`](iot_setup_guide.md)**

---

## 前置需求｜Prerequisites

### 工具安裝｜Required Tools

| 工具 Tool | 版本 Version | 安裝方式 |
|---|---|---|
| **AWS CLI** | v2+ | [安裝指南](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) |
| **Terraform** | >= 1.0 | [安裝指南](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) |

> **Windows 安裝補充｜Windows Installation Note:**
> HashiCorp 官方安裝文件（截至 2026/02）在 Windows 平台僅列出 [Chocolatey](https://community.chocolatey.org/packages/terraform) 作為套件管理器安裝方式：
> ```powershell
> choco install terraform
> ```
> 若你的環境沒有 Chocolatey，也可以考慮直接使用 [winget](https://winstall.app/apps/Hashicorp.Terraform) 安裝（社群維護的套件，非 HashiCorp 官方提供）：
> ```powershell
> winget install Hashicorp.Terraform
> ```
| **Python** | 3.9 | Lambda runtime 需要 |

### AWS 帳號設定｜AWS Account Setup

1. 建立 AWS 帳號或使用現有帳號
2. 建立 IAM User 並賦予 `AdministratorAccess`（或依最小權限原則設定）
3. 設定 AWS CLI credentials：

```bash
aws configure
# AWS Access Key ID: <your-access-key>
# AWS Secret Access Key: <your-secret-key>
# Default region name: us-east-1
# Default output format: json
```

4. 確認設定正確：

```bash
aws sts get-caller-identity
```

---

## 部署架構概覽｜Deployment Overview

所有 Terraform 設定集中在 `deployment/infra/`，執行 `terraform apply` 即可從零建立完整 AWS 基礎設施：

```
deployment/infra/
├── main.tf              # Provider 設定（AWS region, Terraform 版本）
├── variables.tf         # 輸入變數（region, notification_email）
├── outputs.tf           # 輸出值（API URL, Cognito ID 等）
├── iam.tf               # IAM Role（Lambda 執行角色 + Scheduler 角色）
├── lambda.tf            # 16 個 Lambda 函式定義
├── dynamodb.tf          # WasherStatus & UserInfo 資料表（含 Stream）
├── sns.tf               # 3 個 SNS Topic + Email Subscription
├── s3.tf                # S3 Bucket（影像儲存 + 靜態網站）
├── cognito.tf           # Cognito User Pool + Client
├── api_gateway.tf       # IOT API Gateway REST API（4 個端點 + CORS + Cognito auth）
├── api_gateway_express.tf # Express API Gateway（proxy 端點，/washer, /user, /item）
├── iot.tf               # IoT Thing + 6 條 Topic Rules + Device Policy
├── triggers.tf          # DynamoDB Stream → Lambda + S3 → Lambda 觸發器
├── cloudwatch.tf        # CloudWatch Metric Alarm
└── terraform.tfvars.example  # 變數範本
```

原始 AWS 部署的匯出紀錄保存在 `deployment/reference/generated/`，僅供參考。

### Lambda 部署包｜Lambda Deployment Packages

所有 Lambda 函式的 `.zip` 部署包位於：

```
deployment/lambda/
├── team06-RekognizeTimeAndUpdateDB.zip
├── team06-SendReservedUserNotification.zip
├── team06-SendUserLeftTimeAlert.zip
├── team06_ActivateEvent.zip
├── team06_CheckAndReleaseWasher.zip
├── team06_DelayedShadowUpdate.zip
├── team06_EndWashSession.zip
├── team06_FinishWash.zip
├── team06_HandleEndRequest_UnlockWasher.zip
├── team06_HandleReserveRequest.zip
├── team06_HandleUseRequest_NoReservation.zip
├── team06_HandleUseRequest_WithReservation.zip
├── team06_StartWash.zip
├── team06_V2base64toS3.zip
├── team06_WasherHasLocked.zip
├── team06_WasherHasUnlocked.zip
├── team06_upload.zip
└── express.zip
```

---

## 部署步驟｜Step-by-Step Deployment

### Step 1: 設定 Terraform 變數

```bash
cd deployment/infra
cp terraform.tfvars.example terraform.tfvars
# 編輯 terraform.tfvars，填入你的通知 Email
```

> `terraform.tfvars` 已加入 `.gitignore`，不會被 commit 到 git，你的個人資訊不會上傳至 GitHub。

`terraform.tfvars` 範例：
```hcl
notification_email = "your-email@example.com"
# aws_region = "us-east-1"  # 選填，預設 us-east-1

# S3 bucket 名稱（必須全球唯一，請改成自己的名稱）
s3_bucket_images  = "your-team-times-image"
s3_bucket_website = "your-team-website"
```

### Step 2: 初始化 Terraform

```bash
terraform init
```

這會下載 AWS Provider plugin 並初始化 backend。

### Step 3: 檢視部署計畫

```bash
terraform plan
```

確認將建立的資源清單：

- **IAM**: Lambda 執行角色 + EventBridge Scheduler 角色
- **DynamoDB**: 2 tables（WasherStatus, UserInfo）含 Stream
- **Lambda**: 16 functions
- **S3**: 2 buckets（由 `terraform.tfvars` 設定名稱）+ S3 event notification
- **SNS**: 3 topics with email subscriptions
- **API Gateway**: 2 REST APIs（team06-iot-api 含 4 端點 + team06-express 含 proxy 端點）+ Cognito authorizer
- **Cognito**: 1 User Pool + Client
- **IoT Core**: 1 Thing + 6 Topic Rules + Device Policy
- **CloudWatch**: Rekognition 監控告警
- **Triggers**: DynamoDB Stream → Lambda mappings

> **S3 Bucket 名稱注意事項：** S3 bucket 名稱是全球唯一的。預設值帶有 `-temp` 後綴，部署前請在 `terraform.tfvars` 中修改 `s3_bucket_images` 和 `s3_bucket_website` 為你自己的名稱。Terraform 會自動將 bucket 名稱傳給 Lambda 環境變數（`S3_BUCKET_IMAGES` 和 `CORS_ORIGIN`），不需要手動改 Lambda 程式碼。

### Step 4: 執行部署

```bash
terraform apply
```

輸入 `yes` 確認。

### Step 5: 記錄輸出值

部署完成後，記下以下重要的資源識別碼：

```bash
terraform output
```

各輸出值的用途說明：

| 輸出名稱 Output | 用途說明 Purpose |
|---|---|
| `api_gateway_invoke_url` | IOT API Gateway 的基礎 URL，前端呼叫 `/use`、`/reserve`、`/unlock` 等端點時需要此 URL |
| `express_api_invoke_url` | Express API Gateway 的基礎 URL，前端呼叫 `/washer`、`/user`、`/item` 等端點時需要此 URL |
| `cognito_user_pool_id` | Cognito User Pool ID，前端登入/註冊功能需要此值來識別使用哪個 User Pool |
| `cognito_client_id` | Cognito App Client ID，前端呼叫 Cognito 認證 API 時需要此值，用於取得 JWT Token |
| `s3_website_endpoint` | S3 靜態網站的 URL，部署前端後可透過此網址存取網頁 |
| `s3_bucket_images` | 儲存洗衣機拍照影像的 S3 bucket 名稱，上傳前端檔案及 Lambda 讀取影像時會用到 |
| `sns_topic_reserved_notification` | 預約通知的 SNS Topic ARN，當預約使用者的洗衣機可用時，透過此 Topic 發送 Email 通知 |
| `sns_topic_left_time_alert` | 剩餘時間提醒的 SNS Topic ARN，洗衣倒數剩 3 分鐘或結束時，透過此 Topic 發送提醒 |
| `sns_topic_rekognition_alarm` | Rekognition 異常告警的 SNS Topic ARN，當 OCR 辨識失敗次數超過閾值時發送告警 |
| `iot_thing_name` | IoT Thing 名稱，Raspberry Pi 程式中設定 Device Shadow 時需對應此名稱 |
| `iot_endpoint` | IoT Core MQTT endpoint，Raspberry Pi 連線 AWS IoT（MQTT over TLS）時需要此位址 |
| `scheduler_role_arn` | EventBridge Scheduler 的 IAM Role ARN，Lambda 建立排程任務（如延遲開鎖、預約到期檢查）時需要此角色 |

### Step 6: 確認 SNS 訂閱 Email

`terraform apply` 完成後，通知 Email 會收到一封 AWS 的訂閱確認信。**必須點擊信中的「Confirm subscription」連結**，否則所有通知都不會送達。

> 若沒收到確認信，請至 AWS SNS Console → Subscriptions，確認訂閱狀態是否為 `PendingConfirmation`，並手動重新傳送確認信。

### Step 7: 初始化 DynamoDB 資料

`terraform apply` 完成後，`team06-WasherStatus` 資料表是空的。必須手動寫入初始洗衣機資料，否則 `GET /scan` 不會回傳任何機台。

**Bash（Linux / Mac / Git Bash）：**
```bash
aws dynamodb put-item \
  --table-name team06-WasherStatus \
  --region us-east-1 \
  --item '{
    "washer_id": {"N": "1"},
    "in_use": {"BOOL": false},
    "reserved": {"BOOL": false},
    "door_locked": {"BOOL": false},
    "vibration": {"BOOL": false},
    "time": {"N": "0"}
  }'
```

**PowerShell（Windows）：**
```powershell
aws dynamodb put-item --table-name team06-WasherStatus --region us-east-1 --item '{\"washer_id\":{\"N\":\"1\"},\"in_use\":{\"BOOL\":false},\"reserved\":{\"BOOL\":false},\"door_locked\":{\"BOOL\":false},\"vibration\":{\"BOOL\":false},\"time\":{\"N\":\"0\"}}'
```

確認寫入成功：
```bash
aws dynamodb scan --table-name team06-WasherStatus --region us-east-1
```

### Step 8: 建立 Cognito 使用者

建立一個可以登入系統的使用者帳號。

**Bash（Linux / Mac / Git Bash）：**
```bash
# 取得 User Pool ID（從 Step 5 的 terraform output）
USER_POOL_ID=$(cd deployment/infra && terraform output -raw cognito_user_pool_id)

# 建立使用者
aws cognito-idp admin-create-user \
  --user-pool-id $USER_POOL_ID \
  --username your-email@example.com \
  --user-attributes Name=email,Value=your-email@example.com \
  --temporary-password TempPass123! \
  --region us-east-1

# 設定永久密碼（必做，否則前端登入時會卡在「需要變更密碼」流程）
aws cognito-idp admin-set-user-password \
  --user-pool-id $USER_POOL_ID \
  --username your-email@example.com \
  --password TempPass123! \
  --permanent \
  --region us-east-1
```

**PowerShell（Windows）：**
```powershell
# 取得 User Pool ID
cd deployment\infra
$USER_POOL_ID = terraform output -raw cognito_user_pool_id

# 建立使用者
aws cognito-idp admin-create-user --user-pool-id $USER_POOL_ID --username "your-email@example.com" --user-attributes Name=email,Value=your-email@example.com --temporary-password "TempPass123!" --region us-east-1

# 設定永久密碼（必做）
aws cognito-idp admin-set-user-password --user-pool-id $USER_POOL_ID --username "your-email@example.com" --password "TempPass123!" --permanent --region us-east-1
```

> **為什麼需要 `admin-set-user-password --permanent`？**
> `admin-create-user` 建立的帳號預設為 `FORCE_CHANGE_PASSWORD` 狀態。若沒有設定永久密碼，使用者嘗試登入時 Cognito 會要求變更密碼，但本專案前端並未實作此流程，導致登入失敗。

**密碼規則：** 最少 8 字元，需包含大寫字母、小寫字母、數字、特殊符號。

### Step 9: 部署前端網頁

前端編譯後的 JS 中包含 Cognito Client ID 及 API Gateway URL，這些值在每次重新部署後都會改變，必須透過部署腳本自動注入新值再上傳至 S3。

```bash
# 在專案根目錄執行（Linux / Mac / Git Bash）
bash deployment/scripts/deploy_frontend.sh
```

腳本會自動：
1. 讀取 Terraform 輸出的 Cognito Client ID、IoT API URL、Express API URL
2. 替換前端 JS bundle 中的舊值
3. 上傳至 S3 靜態網站 bucket

> **Windows PowerShell 使用者：** 請改用 Git Bash 執行此腳本。

部署完成後，網站可透過以下 URL 存取：
```
http://<s3_bucket_website>.s3-website-us-east-1.amazonaws.com
```

### Step 10: 設定 IoT 裝置憑證

> **Terraform 已自動建立 IoT Thing（`team06_IoT`）和 IoT Policy。**
> 你只需要在 AWS Console 手動建立 Certificate 並下載憑證檔案。

1. 前往 [AWS IoT Console](https://console.aws.amazon.com/iot/) → **Security → Certificates**
2. 點擊 **Create certificate**（使用 Auto-generate）
3. 下載三個檔案：
   - `AmazonRootCA1.pem`
   - `xxxxxxxx-certificate.pem.crt`
   - `xxxxxxxx-private.pem.key`
4. 點擊 **Activate**，啟用此憑證
5. 在憑證頁面 → **Actions → Attach policy**，選擇 `team06-iot-policy`
6. 在憑證頁面 → **Actions → Attach thing**，選擇 `team06_IoT`
7. 將憑證檔案放入專案 `config/` 目錄（詳見 Step 11）

### Step 11: 啟動 Raspberry Pi 程式

完整的硬體接線、憑證設定與程式啟動步驟請見：

**[docs/iot_setup_guide.md](iot_setup_guide.md)**

---

## Lambda 環境變數設定｜Lambda Environment Variables

以下 Lambda 函式需要設定環境變數：

| Lambda 函式 | 環境變數 | 值 |
|---|---|---|
| `team06-SendReservedUserNotification` | `SNS_TOPIC_ARN` | SNS topic `team06-SendReservedUserNotification` 的 ARN |
| `team06-SendUserLeftTimeAlert` | `SendUserLeftTimeAlert` | SNS topic `team06-SendUserLeftTimeAlert` 的 ARN |
| `team06_ActivateEvent` | `TARGET_LAMBDA_ARN` | Lambda `team06_CheckAndReleaseWasher` 的 ARN |
| `team06_ActivateEvent` | `SCHEDULER_ROLE_ARN` | EventBridge Scheduler 使用的 IAM Role ARN |
| `team06_EndWashSession` | `TARGET_LAMBDA_ARN` | Lambda `team06_DelayedShadowUpdate` 的 ARN |
| `team06_EndWashSession` | `SCHEDULER_ROLE_ARN` | EventBridge Scheduler 使用的 IAM Role ARN |

這些在 `lambda.tf` 中已定義，Terraform apply 時會自動設定。

---

## Lambda IAM 權限｜Required IAM Permissions

Lambda 執行角色需要以下權限：

```
DynamoDB:      GetItem, PutItem, UpdateItem, Scan, Query
IoT Data:      UpdateThingShadow
Rekognition:   DetectText
S3:            GetObject, PutObject
SNS:           Publish
Lambda:        InvokeFunction
Scheduler:     CreateSchedule, DeleteSchedule
IAM:           PassRole (for EventBridge Scheduler)
CloudWatch:    PutMetricData (自動包含)
```

---

## 觸發器設定｜Trigger Configuration

部署後需確認以下觸發器已正確連結：

### API Gateway → Lambda

| API 路徑 | Lambda 函式 |
|---|---|
| POST `/use` | `team06_HandleUseRequest_NoReservation` |
| POST `/use_reserved` | `team06_HandleUseRequest_WithReservation` |
| POST `/reserve` | `team06_HandleReserveRequest` |
| POST `/unlock` | `team06_HandleEndRequest_UnlockWasher` |

### S3 Event → Lambda

| S3 Bucket | Event | Lambda 函式 |
|---|---|---|
| `s3_bucket_images`（terraform.tfvars 設定的名稱） | `s3:ObjectCreated:*` | `team06-RekognizeTimeAndUpdateDB` |

### DynamoDB Stream → Lambda

| DynamoDB Table | Lambda 函式 | 觸發條件 |
|---|---|---|
| `team06-WasherStatus` | `team06-SendUserLeftTimeAlert` | `time` 欄位變更為 3 或 0 |
| `team06-WasherStatus` | `team06_ActivateEvent` | `reserved` 變更為 true |
| `team06-WasherStatus` | `team06_EndWashSession` | `in_use` 變更為 false |

### IoT Rule → Lambda

| IoT Topic / Shadow | Lambda 函式 |
|---|---|
| Shadow: `door_locked` reported = true | `team06_WasherHasLocked` |
| Shadow: `door_locked` reported = false | `team06_WasherHasUnlocked` |
| Shadow: `vibration_detected` = true | `team06_StartWash` |
| Shadow: `vibration_detected` = false | `team06_FinishWash` |
| Topic: `device/camera/image` | `team06_V2base64toS3` |

---

## SNS 通知設定｜SNS Configuration

### 修改通知 Email

通知 Email 透過 Terraform 變數設定，不需要手動改 `.tf` 檔案：

1. 編輯 `deployment/infra/terraform.tfvars`
2. 修改 `notification_email = "your-email@example.com"`
3. 重新 `terraform apply`
4. 至信箱點擊確認訂閱連結

---



## 驗證部署｜Verify Deployment

### 1. 檢查 DynamoDB 資料表

```bash
aws dynamodb list-tables --region us-east-1
# 應看到 team06-WasherStatus 和 team06-UserInfo
```

### 2. 測試 API 端點

```bash
# 取得 Cognito token（需先有已確認的使用者）
TOKEN=$(aws cognito-idp initiate-auth \
  --auth-flow USER_PASSWORD_AUTH \
  --client-id <client-id> \
  --auth-parameters USERNAME=<user>,PASSWORD=<pass> \
  --query 'AuthenticationResult.IdToken' --output text)

# 測試 API
curl -X POST https://<api-id>.execute-api.us-east-1.amazonaws.com/prod/reserve \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"user_id": "testuser", "washer_id": 1}'
```

### 3. 檢查 Lambda 函式

```bash
aws lambda list-functions --region us-east-1 \
  --query 'Functions[?starts_with(FunctionName, `team06`)].FunctionName'
```

### 4. 檢查 IoT Thing

```bash
aws iot describe-thing --thing-name team06_IoT --region us-east-1
```

---

## 清理資源｜Cleanup

若要移除所有部署的資源：

```bash
cd deployment/infra
terraform destroy
```

**注意**：這會刪除所有 DynamoDB 資料、S3 檔案等。請確認備份後再執行。

---

## 常見問題｜Troubleshooting

### Terraform apply 失敗

- 確認 AWS credentials 正確且有足夠權限
- 確認 region 設定為 `us-east-1`
- S3 bucket 名稱必須全域唯一，若衝突需修改名稱

### Lambda 執行錯誤

- 至 CloudWatch Logs 查看對應 Lambda 的 log group
- 確認環境變數已正確設定
- 確認 IAM Role 有足夠的權限
- **修改 IAM Policy 後 Lambda 仍報權限錯誤**：Lambda 執行環境會快取 credentials，修改 IAM 後可能需要等待幾分鐘讓舊環境失效，或重新觸發一次 Lambda（建立新的執行環境）才會套用新權限

### SNS 收不到通知

- 確認已至信箱點擊訂閱確認連結（Step 6）
- SNS Subscription 有設定 FilterPolicy，要求 message 必須帶有 `user_email_address` MessageAttribute，且值需與訂閱的 Email 相符。Lambda 程式碼已處理此邏輯，若自行測試 `aws sns publish` 需手動加上：
  ```bash
  --message-attributes '{"user_email_address":{"DataType":"String","StringValue":"your-email@example.com"}}'
  ```
- 至 AWS SNS Console 確認 Subscription 狀態為 `Confirmed`（非 `PendingConfirmation`）

### IoT 裝置連不上

- 確認憑證檔案路徑正確
- 確認 IoT endpoint 正確（可至 AWS IoT Console 查看）
- 確認 IoT Policy 允許 Connect、Publish、Subscribe、Receive
