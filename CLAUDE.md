# fanc-terraform

PitaScho のカウンセリング管理サービス「fanc」の AWS インフラを管理する Terraform リポジトリ。

## 構成

- **プロバイダー**: AWS v5.10.0
- **環境**: `stg/`（staging）のみ。prod 環境はまだ存在しない。
- **モジュール分割**: なし。リソース種別ごとにファイル分割（`vpc.tf`, `ecs.tf`, `rds.tf` 等 20 ファイル）
- **backend**: S3（バケット `fanc-terraform-backend-stg`、state: `terraform.tfstate`、リージョン `us-east-1`）。DynamoDB ロックは未設定。

## 管理リソース

- **ネットワーク**: VPC, サブネット, セキュリティグループ, NACL, IGW, NAT Gateway
- **コンピュート**: ECS（Fargate）, EC2 Bastion
- **DB**: RDS MySQL 8.0.32
- **ロードバランシング**: ALB
- **CDN / DNS**: CloudFront, Route53
- **ストレージ**: S3（バージョニング有効）
- **コンテナレジストリ**: ECR
- **IAM**: ロール・ポリシー

## 主要コマンド

README に記載はないため一般的な手順。`stg/` ディレクトリ内で実行する。

```bash
cd stg
terraform init
terraform plan
terraform apply
```

## 関連リポジトリ

- [fanc-front](https://github.com/kudotaka0421/fanc-front) — フロントエンド
- [fanc-api](https://github.com/kudotaka0421/fanc-api) — バックエンド API
