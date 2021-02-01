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
        "name": "HOSTNAME",
        "value": "${hostname}"
      },
      {
        "name": "ADMIN_USER",
        "value": "${admin_user}"
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