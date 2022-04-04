terraform {
    backend "s3" {
        encrypt = false
        #bucket = "casestudy-tf-bucket-s3"
        #dynamodb_table = "casestudy-tf-state-lock-dynamo"
        bucket = "tests3pipeline"
        dynamodb_table = "dynamodbtest"
        key = "./terra/terraform.tfstate.d/dev/terraform.tfstate"
        region = "us-east-1"
    }
}