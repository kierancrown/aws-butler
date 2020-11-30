variable "butler_config" {
  description = "The config objrct passed to the butler lambda"
  type = object({
    Region          = string,
    ExcludeRegions  = list(string)
    ExcludeServices = list(string)
  })
  default = {
    Region  = "eu-west-1"
    ExcludeRegions = ["us-west-1"]
    ExcludeServices = []
  }
}

variable "butler_alerts" {
  type = list(object({
    alertType     = string
    triggerValue  = number
  }))
  description = "Configure alerts for each service"
  default = [
      {
        alertType = "lambda_function_threshold"
        triggerValue = 4
      },
      {
        alertType = "s3_bucket_threshold"
        triggerValue = 5
      }
  ]
}

variable "butler_contacts" {
  type = list(string)
  description = "A list of email addresses Butler will alert"
  default = [
    "kieran.crown@gmail.com"
  ]
}