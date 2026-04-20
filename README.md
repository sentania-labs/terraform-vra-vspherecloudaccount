# terraform-vra-vspherecloudaccount

Terraform module — registers a vSphere vCenter instance as a cloud account in vRA / Aria Automation, enumerates its regions, and applies capability tags.

## Usage example

```hcl
module "vsphere_account" {
  source = "sentania-labs/vspherecloudaccount/vra"

  name        = "vcf-lab-wld01"
  hostname    = "vcf-lab-vcenter-wld01.int.sentania.net"
  username    = var.vcenter_user
  password    = var.vcenter_password
  nsx_manager = "vcf-lab-nsxmgr-wld01"

  enabled_datacenters = ["vcf-lab-wld01-dc01"]

  capability_tags = [
    { key = "cloud", value = "vsphere" },
    { key = "az",    value = "az1" }
  ]
}
```

See `examples/` for a complete working configuration.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_vra"></a> [vra](#requirement\_vra) | >= 0.3.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vra"></a> [vra](#provider\_vra) | >= 0.3.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vra_cloud_account_vsphere.this](https://registry.terraform.io/providers/vmware/vra/latest/docs/resources/cloud_account_vsphere) | resource |
| [vra_region_enumeration_vsphere.this](https://registry.terraform.io/providers/vmware/vra/latest/docs/data-sources/region_enumeration_vsphere) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accept_self_signed_cert"></a> [accept\_self\_signed\_cert](#input\_accept\_self\_signed\_cert) | Accept self-signed certs? | `bool` | `true` | no |
| <a name="input_capability_tags"></a> [capability\_tags](#input\_capability\_tags) | Capability tags to be applied to the Cloud Account | `list(map(string))` | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | A description for the cloud account | `string` | `"Manged by TF - Do not edit!"` | no |
| <a name="input_enabled_datacenters"></a> [enabled\_datacenters](#input\_enabled\_datacenters) | An array of vSphere Datacenters to enable for automation | `list(any)` | n/a | yes |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | The FQDN of the vcenter server | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the cloud account | `string` | n/a | yes |
| <a name="input_nsx_manager"></a> [nsx\_manager](#input\_nsx\_manager) | The NSX manager connected to this vCenter | `string` | `""` | no |
| <a name="input_password"></a> [password](#input\_password) | The password for the service account | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | The username for the service account | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_account"></a> [cloud\_account](#output\_cloud\_account) | n/a |
<!-- END_TF_DOCS -->
