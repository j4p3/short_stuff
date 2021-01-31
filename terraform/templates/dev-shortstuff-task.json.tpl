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
        "name": "DATABASE_URL",
        "valueFrom": "${database_url}"
      },
      "environment": [
        {
          "name": "db_name",
          "value": "${db_name}"
        },
        {
          "name": "db_username",
          "value": "${db_username}"
        },
        {
          "name": "db_host",
          "value": "${db_host}"
        }
      ]
    ]
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