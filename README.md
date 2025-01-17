<!-- BEGIN_TF_DOCS -->
# Terraform Module: Wayfinder on AWS

The "terraform-aws-wayfinder" Terraform Module can be used to provision and manage a licensed edition of [Appvia Wayfinder](https://www.appvia.io/product/) on AWS.

## Requirements

To run this module, you will need the following:
1. Product license key: Contact sales@appvia.io for more information.
2. IDP App configuration details: Wayfinder integrates with an IDP for managing user access. You will need a valid Client ID, Client Secret and Server URL (or Azure Tenant ID) for initial configuration.
3. A public Route53 DNS Zone: This module will create DNS records for the Wayfinder API and UI endpoints, and performs a DNS01 challenge via the LetsEncrypt Issuer for valid domain certificates.
4. Existing VPC and Subnets: This module will deploy an EKS Cluster and so requires an existing VPC with outbound internet connectivity. Public ingress is not required, both EKS and Wayfinder ingress can be configured with an internal endpoint.
5. Network Resource Tags:
  1. Public Subnets should have the tag `"kubernetes.io/role/elb" = 1`
  2. Network Resource Tags: Private Subnets should have the tag `"kubernetes.io/role/internal-elb" = 1`

### Connecting to an Identity Provider

Wayfinder integrates with an IDP for managing user access. You will need a valid Client ID, Client Secret and Server URL (or Azure Tenant ID) for initial configuration.

The Authorized Redirect URI for the IDP Application should be set to: `https://${wayfinder_domain_name_api}/oauth/callback`

**Note:** If you are using Azure Active Directory, you must:
1. Set `azureTenantId` to your Azure Tenant ID (`serverUrl` is not required)
2. Set the IDP type to `aad`

#### Example: Generic IDP Configuration

```hcl
wayfinder_idp_details = {
  type         = "generic"
  clientId     = "IDP-APP-CLIENT-ID"
  clientSecret = "IDP-APP-CLIENT-SECRET"
  serverUrl    = "https://example.okta.com" # Or "https://example.auth0.com/"
}
```

#### Example: Azure AD IDP Configuration

```hcl
wayfinder_idp_details = {
  type          = "aad"
  clientId      = "IDP-APP-CLIENT-ID"
  clientSecret  = "IDP-APP-CLIENT-SECRET"
  azureTenantId = "12345678-1234-1234-1234-123456789012"
}
```

## Deployment

Please see the [examples](./examples) directory to see how to deploy this module.

## Updating Docs

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:
1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_ebs_csi_driver_addon_version"></a> [aws\_ebs\_csi\_driver\_addon\_version](#input\_aws\_ebs\_csi\_driver\_addon\_version) | The version to use for the AWS EBS CSI driver | `string` | `"v1.19.0-eksbuild.2"` | no |
| <a name="input_aws_vpc_cni_addon_version"></a> [aws\_vpc\_cni\_addon\_version](#input\_aws\_vpc\_cni\_addon\_version) | AWS VPC CNI Addon version to use | `string` | `"v1.12.6-eksbuild.2"` | no |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR blocks which can access the Amazon EKS API server endpoint | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_cluster_security_group_additional_rules"></a> [cluster\_security\_group\_additional\_rules](#input\_cluster\_security\_group\_additional\_rules) | List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source | `any` | `{}` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The Kubernetes version to use for the EKS cluster | `string` | `"1.25"` | no |
| <a name="input_clusterissuer_email"></a> [clusterissuer\_email](#input\_clusterissuer\_email) | The email address to use for the cert-manager cluster issuer | `string` | n/a | yes |
| <a name="input_coredns_addon_version"></a> [coredns\_addon\_version](#input\_coredns\_addon\_version) | CoreDNS Addon version to use | `string` | `"v1.9.3-eksbuild.5"` | no |
| <a name="input_disable_internet_access"></a> [disable\_internet\_access](#input\_disable\_internet\_access) | Whether to disable internet access for EKS and the Wayfinder ingress controller | `bool` | `false` | no |
| <a name="input_dns_zone_arn"></a> [dns\_zone\_arn](#input\_dns\_zone\_arn) | The AWS Route53 DNS Zone ARN to use (e.g. arn:aws:route53:::hostedzone/ABCDEFG1234567) | `string` | n/a | yes |
| <a name="input_ebs_csi_kms_cmk_ids"></a> [ebs\_csi\_kms\_cmk\_ids](#input\_ebs\_csi\_kms\_cmk\_ids) | List of KMS CMKs to allow EBS CSI to manage encrypted volumes. This is required if EBS encryption is set at the account level with a default KMS CMK. | `list(string)` | `[]` | no |
| <a name="input_eks_ng_capacity_type"></a> [eks\_ng\_capacity\_type](#input\_eks\_ng\_capacity\_type) | The capacity type to use for the EKS managed node group | `string` | `"ON_DEMAND"` | no |
| <a name="input_eks_ng_desired_size"></a> [eks\_ng\_desired\_size](#input\_eks\_ng\_desired\_size) | The desired size to use for the EKS managed node group | `number` | `2` | no |
| <a name="input_eks_ng_instance_types"></a> [eks\_ng\_instance\_types](#input\_eks\_ng\_instance\_types) | The instance types to use for the EKS managed node group | `list(string)` | <pre>[<br>  "t3.xlarge"<br>]</pre> | no |
| <a name="input_eks_ng_minimum_size"></a> [eks\_ng\_minimum\_size](#input\_eks\_ng\_minimum\_size) | The minimum size to use for the EKS managed node group | `number` | `2` | no |
| <a name="input_enable_k8s_resources"></a> [enable\_k8s\_resources](#input\_enable\_k8s\_resources) | Whether to enable the creation of Kubernetes resources for Wayfinder (helm and kubectl manifest deployments) | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name we are provisioning | `string` | `"production"` | no |
| <a name="input_kms_key_administrators"></a> [kms\_key\_administrators](#input\_kms\_key\_administrators) | A list of IAM ARNs for EKS key administrators. If no value is provided, the current caller identity is used to ensure at least one key admin is available | `list(string)` | `[]` | no |
| <a name="input_kube_proxy_addon_version"></a> [kube\_proxy\_addon\_version](#input\_kube\_proxy\_addon\_version) | Kube Proxy Addon version to use | `string` | `"v1.25.11-eksbuild.1"` | no |
| <a name="input_node_security_group_additional_rules"></a> [node\_security\_group\_additional\_rules](#input\_node\_security\_group\_additional\_rules) | List of additional security group rules to add to the node security group created. Set `source_cluster_security_group = true` inside rules to set the `cluster_security_group` as source | `any` | `{}` | no |
| <a name="input_permissions_boundary_policy_arn"></a> [permissions\_boundary\_policy\_arn](#input\_permissions\_boundary\_policy\_arn) | ARN of the AWS permissions boundary policy to apply to IAM roles | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of private Subnet IDs to launch the Wayfinder EKS Nodes onto | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources created | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID for the Wayfinder EKS Cluster to be built within | `string` | n/a | yes |
| <a name="input_wayfinder_domain_name_api"></a> [wayfinder\_domain\_name\_api](#input\_wayfinder\_domain\_name\_api) | The domain name to use for the Wayfinder API (e.g. api.wayfinder.example.com) | `string` | n/a | yes |
| <a name="input_wayfinder_domain_name_ui"></a> [wayfinder\_domain\_name\_ui](#input\_wayfinder\_domain\_name\_ui) | The domain name to use for the Wayfinder UI (e.g. portal.wayfinder.example.com) | `string` | n/a | yes |
| <a name="input_wayfinder_idp_details"></a> [wayfinder\_idp\_details](#input\_wayfinder\_idp\_details) | The IDP details to use for Wayfinder to enable SSO | <pre>object({<br>    type          = string<br>    clientId      = string<br>    clientSecret  = string<br>    serverUrl     = optional(string)<br>    azureTenantId = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_wayfinder_instance_id"></a> [wayfinder\_instance\_id](#input\_wayfinder\_instance\_id) | The instance ID to use for Wayfinder. This can be left blank and will be autogenerated. | `string` | `""` | no |
| <a name="input_wayfinder_license_key"></a> [wayfinder\_license\_key](#input\_wayfinder\_license\_key) | The license key to use for Wayfinder | `string` | n/a | yes |
| <a name="input_wayfinder_release_channel"></a> [wayfinder\_release\_channel](#input\_wayfinder\_release\_channel) | The release channel to use for Wayfinder | `string` | `"wayfinder-releases"` | no |
| <a name="input_wayfinder_version"></a> [wayfinder\_version](#input\_wayfinder\_version) | The version to use for Wayfinder | `string` | `"v2.2.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | The base64 encoded certificate data for the Wayfinder EKS cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint for the Wayfinder EKS Kubernetes API |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the Wayfinder EKS cluster |
| <a name="output_cluster_oidc_provider_arn"></a> [cluster\_oidc\_provider\_arn](#output\_cluster\_oidc\_provider\_arn) | The ARN of the OIDC provider for the Wayfinder EKS cluster |
| <a name="output_wayfinder_api_url"></a> [wayfinder\_api\_url](#output\_wayfinder\_api\_url) | The URL for the Wayfinder API |
| <a name="output_wayfinder_iam_role_arn"></a> [wayfinder\_iam\_role\_arn](#output\_wayfinder\_iam\_role\_arn) | The ARN of the IAM role used by Wayfinder |
| <a name="output_wayfinder_instance_identifier"></a> [wayfinder\_instance\_identifier](#output\_wayfinder\_instance\_identifier) | The unique identifier for the Wayfinder instance |
| <a name="output_wayfinder_ui_url"></a> [wayfinder\_ui\_url](#output\_wayfinder\_ui\_url) | The URL for the Wayfinder UI |
<!-- END_TF_DOCS -->