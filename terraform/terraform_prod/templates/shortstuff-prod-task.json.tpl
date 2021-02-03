[
  {
    "image": "${repository_url}:latest",
    "name": "${task_name}",
    "portMappings": [
      {
          "containerPort": 4000
      }
    ],
    "secrets": [
      {
        "name": "DB_PASSWORD",
        "valueFrom": "${db_password_secret}"
      },
      {
        "name": "SECRET_KEY_BASE",
        "valueFrom": "${secret_key_base_secret}"
      },
      {
        "name": "SIGNING_SALT",
        "valueFrom": "${signing_salt_secret}"
      },
      {
        "name": "ADMIN_PASSWORD",
        "valueFrom": "${admin_password_secret}"
      },
      {
        "name": "TWILIO_AUTH_TOKEN",
        "valueFrom": "${twilio_auth_token_secret}"
      }
      
    ],
    "environment": [
      {
        "name": "MIX_ENV",
        "value": "${mix_env}"
      },
      {
        "name": "DB_NAME",
        "value": "${db_name}"
      },
      {
        "name": "DB_USER",
        "value": "${db_user}"
      },
      {
        "name": "DB_HOST",
        "value": "${db_host}"
      },
      {
        "name": "ADMIN_USER",
        "value": "${admin_user}"
      },
      {
        "name": "TWILIO_NOTIFY_SERVICE_ID",
        "value": "${twilio_notify_service_id}"
      },
      {
        "name": "TWILIO_ACCOUNT_ID",
        "value": "${twilio_account_id}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${log_region}",
        "awslogs-stream-prefix": "ecs-fargate"
      }
    }
  }
]