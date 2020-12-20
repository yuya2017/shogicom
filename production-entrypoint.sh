#!/bin/sh

set -e

rm -f /application/tmp/pids/server.pid

# 1. ハイブリッドアクティベーションの作成
SSM_ACTIVATE_INFO=`aws ssm create-activation --iam-role service-role/AmazonEC2RunCommandRoleForManagedInstances --registration-limit 30 --region ap-northeast-1 --default-instance-name medley-blog-fargate-container`

# 2. アウトプットからアクティベーションコード/IDの抽出
SSM_ACTIVATE_CODE=`echo $SSM_ACTIVATE_INFO | jq -r '.ActivationCode'`
SSM_ACTIVATE_ID=`echo $SSM_ACTIVATE_INFO | jq -r '.ActivationId'`

# 3. コンテナ自身をマネージドインスタンスへの登録
amazon-ssm-agent -register -code $SSM_ACTIVATE_CODE -id $SSM_ACTIVATE_ID -region "ap-northeast-1"

# 4. SessionManagerエージェントの起動
amazon-ssm-agent &

exec "$@"
