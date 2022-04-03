terraform {
    backend "s3" {
        encrypt = false
        bucket = "case-study-tf-bucket-s3"
        dynamodb_table = "case-study-tf-state-lock-dynamo"
        key = "./Profiles/terraform.tfstate.d/dev/terraform.tfstate"
        region = "us-east-1"
    }
}