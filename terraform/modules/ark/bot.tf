## zipに固めるタイミングでnode_moduleの依存パッケージがインストール済みである必要がある点に注意
data "archive_file" "bot_function" {
  type        = "zip"
  source_dir  = "${path.module}/../../../js/bot"
  output_path = "${path.module}/bot.zip"
}

module "bot_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "discord-bot"
  description   = "ark server power manager"
  handler       = "src/index.handler"
  runtime       = "nodejs18.x"
  architectures = ["arm64"]

  create_package             = false
  create_lambda_function_url = true

  local_existing_package = data.archive_file.sample_function.output_path

  environment_variables = {
    "DISCORD_APPLICATION_ID"                = var.discord_application_id
    "DISCORD_BOT_ACCESS_TOKEN"              = var.discord_bot_access_token
    "DISCORD_PUBLIC_KEY"                    = var.discord_public_key
    "ARK_SERVER_ID"                         = sakuracloud_server.ark.id
    "SAKURACLOUD_SERVER_POWER_TOKEN"        = var.sakuracloud_server_power_token
    "SAKURACLOUD_SERVER_POWER_TOKEN_SECRET" = var.sakuracloud_server_power_token_secret
  }
}



