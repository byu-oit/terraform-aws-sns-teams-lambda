variable "app_name" {
  type        = string
  description = "The application name to include in the name of resources created. Displayed as a prefix to the Teams message."
}

variable "send_to_teams" {
  type        = bool
  description = "Whether or not to actually send messages to Teams. Recommended to be false for all environments except production."
  default     = true
}

variable "log_retention_in_days" {
  type        = number
  description = "The number of days to retain logs for the sns-to-teams Lambda."
  default     = 14
}

variable "memory_size" {
  type        = number
  description = "The amount of memory for the function."
  default     = 128
}

variable "role_permissions_boundary" {
  type        = string
  description = "The ARN of the role permissions boundary to attach to the Lambda role."
}

variable "teams_webhook_url" {
  type        = string
  description = "The webhook URL to use when sending messages to Teams. This value contains a secret and should be kept safe."
  sensitive   = true
}

variable "sns_topic_arns" {
  type        = set(string)
  description = "The ARNs of the SNS topics you want to see messages for in Teams."
}

variable "timeout" {
  type        = number
  description = "The number of seconds the function is allowed to run."
  default     = 30
}

variable "tags" {
  type        = map(string)
  description = "A map of AWS Tags to attach to each resource created."
  default     = {}
}
