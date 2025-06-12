# API Gatway

## IOT API `team06-iot-api`
### Authorizers
1. Create authorizer
2. name : `team06_Auth`
3. Authorizer type: `Cognito`
4. Choose `team06-UserPool`
### Resources
1. Create resource for each name
    - Resource path : `/`
    - name: `use`, `unlock`, `reserve`, `use_reserved`
2. Go to created resource (e.g. `/use`) : `Enable CORS`
    - Check all boxes
    - Access-Control-Allow-Origin : `S3 Bucket website endpoint link`
3. Go to created resource --> `Create method`
4. Method type: `POST`
5. Integration type: `Lambda function`
    - /use : `team06_HandleUseRequest_NoReservation`
    - /unlock : `team06_HandleEndRequest_UnlockWasher`
    - /reserve : `team06_HandleReserveRequest`
    - /use_reserved : `team06_HandleUseRequest_WithReservation`
6. Go to created method (e.g. `POST`)
    - Go to `Method request`, choose `Edit`
    - Authorization: Choose`team06_Auth` and Save

## Express API `team06-express`
### Authorizers
1. Create authorizer
2. name : `Express_Auth`
3. Authorizer type: `Cognito`
4. Choose `team06-UserPool`
### Resources
1. Create resource for each name
    - Resource path : `/`
    - Enable `Proxy resource`
    - name : `{proxy+}` 
2. Go to created resource (e.g. `/{proxy+}`) : `Enable CORS`
    - Check all boxes
    - Access-Control-Allow-Origin : `S3 Bucket website endpoint link`
3. Go to created resource --> `Create method`
4. Method type: `ANY`
5. Integration type: `Lambda function`
    - `team06-express`
6. Go to created method (e.g. `ANY`)
    - Go to `Method request`, choose `Edit`
    - Authorization: Choose`Express_Auth` and Save

> Note:
Remember to go Lambda & add trigger
    