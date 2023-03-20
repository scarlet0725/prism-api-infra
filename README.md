# PRISM-API-Infra

[prism-api](https://github.com/scarlet0725/prism-api)のインフラ構成のリポジトリです。

# 使い方

環境変数```GOOGLE_CREDENTIALS```にローカルCI/CD用credentials.jsonへのパスをセットする

セットした後に
```bash
terraform init
```

してModuleをセットアップします。

Terraform applyはGithub Actionsで行うためbranchを切ってPRを作成してマージする形で行います。
