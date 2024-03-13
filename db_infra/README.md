<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.cpu_utilization_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_docdb_cluster.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster) | resource |
| [aws_docdb_cluster_instance.example_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_instance) | resource |
| [aws_iam_policy.cloudwatch_sns_publish](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cloudwatch_action_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatch_sns_publish_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_sns_topic.docdb_alarm_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy resources into | `string` | `"eu-west-3"` | no |
| <a name="input_cpu_utilization_threshold"></a> [cpu\_utilization\_threshold](#input\_cpu\_utilization\_threshold) | CPU utilization threshold for triggering the alarm | `number` | `80` | no |
| <a name="input_docdb_cluster_identifier"></a> [docdb\_cluster\_identifier](#input\_docdb\_cluster\_identifier) | Identifier for the DocDB cluster | `string` | `"my-docdb-cluster"` | no |
| <a name="input_docdb_engine"></a> [docdb\_engine](#input\_docdb\_engine) | Engine type for the DocDB cluster | `string` | `"docdb"` | no |
| <a name="input_docdb_instance_class"></a> [docdb\_instance\_class](#input\_docdb\_instance\_class) | Instance class for the DocDB instances | `string` | `"db.t4g.medium"` | no |
| <a name="input_docdb_master_password"></a> [docdb\_master\_password](#input\_docdb\_master\_password) | Master password for the DocDB cluster | `string` | n/a | yes |
| <a name="input_docdb_master_username"></a> [docdb\_master\_username](#input\_docdb\_master\_username) | Master username for the DocDB cluster | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->