# @name: find_instance_globally
# @desc: Finds where an instance id is present within all regions of your aws account. 
# @tags: docker, container
find_instance_globally() {
    local INSTANCE_ID="$1"

    if [[ -z "$INSTANCE_ID" ]]; then
        echo "Usage: find_instance_globally <instance-id>"
        return 1
    fi

    echo "Searching for instance ID: $INSTANCE_ID"
    echo "Search with aws user:"
    whoami_aws

    local REGIONS
    REGIONS=$(aws ec2 describe-regions --query "Regions[*].RegionName" --output text)

    for REGION in $REGIONS; do
        echo "Checking region: $REGION"

        local RESULT
        RESULT=$(aws ec2 describe-instances \
            --region "$REGION" \
            --instance-ids "$INSTANCE_ID" \
            --query "Reservations[*].Instances[*].[InstanceId,State.Name,Tags]" \
            --output text 2>/dev/null)

        if [[ -n "$RESULT" ]]; then
            echo "✅ Found in region: $REGION"
            echo "$RESULT"
            return 0
        fi
    done

    echo "❌ Instance ID $INSTANCE_ID not found in any region."
    return 1
}

