terraform {
    backend "s3" {
        encrypt = false
        bucket = "casestudy-tf-bucket-s3"
        dynamodb_table = "casestudy-tf-state-lock-dynamo"
        key = "./Profiles/terraform.tfstate.d/dev/terraform.tfstate"
        region = "us-east-1"
    }
}