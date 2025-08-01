whoami_aws() {
  AWS_PAGER="" aws sts get-caller-identity \
    --query "{Account:Account, UserId:UserId, Arn:Arn}" \
    --output table
}