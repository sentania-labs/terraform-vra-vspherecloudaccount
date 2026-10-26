mock_provider "vra" {
  override_during = plan

  mock_data "vra_region_enumeration_vsphere" {
    defaults = {
      external_regions = [
        { name = "dc01", external_region_id = "Datacenter:dc-1" },
        { name = "dc02", external_region_id = "Datacenter:dc-2" },
        { name = "dc03", external_region_id = "Datacenter:dc-3" },
      ]
    }
  }
}

variables {
  name                = "test account"
  hostname            = "vcenter.example.com"
  username            = "svc@vsphere.local"
  password            = "not-a-real-password"
  enabled_datacenters = ["dc01", "dc03"]
}

run "filters_to_enabled_datacenters" {
  command = plan

  assert {
    condition     = length(local.filtered_regions) == 2
    error_message = "Only the requested datacenters should be enabled."
  }

  assert {
    condition     = toset([for r in local.filtered_regions : r.name]) == toset(["dc01", "dc03"])
    error_message = "Filtered regions should be dc01 and dc03."
  }
}

run "unknown_datacenter_is_ignored" {
  command = plan

  variables {
    enabled_datacenters = ["dc02", "missing"]
  }

  assert {
    condition     = [for r in local.filtered_regions : r.name] == ["dc02"]
    error_message = "Datacenters absent from the enumeration should be dropped."
  }
}

run "tls_default_accepts_self_signed" {
  command = plan

  assert {
    condition     = data.vra_region_enumeration_vsphere.this.accept_self_signed_cert == true
    error_message = "Data source should accept self-signed certs by default."
  }

  assert {
    condition     = vra_cloud_account_vsphere.this.accept_self_signed_cert == true
    error_message = "Resource should accept self-signed certs by default."
  }
}

run "tls_strict_applies_to_data_source_and_resource" {
  command = plan

  variables {
    accept_self_signed_cert = false
  }

  assert {
    condition     = data.vra_region_enumeration_vsphere.this.accept_self_signed_cert == false
    error_message = "Data source must use strict verification when accept_self_signed_cert is false."
  }

  assert {
    condition     = vra_cloud_account_vsphere.this.accept_self_signed_cert == false
    error_message = "Resource must use strict verification when accept_self_signed_cert is false."
  }
}

run "rejects_url_hostname" {
  command = plan

  variables {
    hostname = "https://vcenter.example.com"
  }

  expect_failures = [var.hostname]
}

run "rejects_empty_username" {
  command = plan

  variables {
    username = ""
  }

  expect_failures = [var.username]
}

run "rejects_empty_password" {
  command = plan

  variables {
    password = ""
  }

  expect_failures = [var.password]
}

run "rejects_empty_tag_key" {
  command = plan

  variables {
    capability_tags = [{ key = "", value = "x" }]
  }

  expect_failures = [var.capability_tags]
}

run "accepts_ipv6_hostname" {
  command = plan

  variables {
    hostname = "2001:db8::10"
  }

  assert {
    condition     = vra_cloud_account_vsphere.this.hostname == "2001:db8::10"
    error_message = "A bare IPv6 literal should be accepted as the hostname."
  }
}

run "accepts_bracketed_ipv6_hostname" {
  command = plan

  variables {
    hostname = "[2001:db8::10]"
  }

  assert {
    condition     = vra_cloud_account_vsphere.this.hostname == "[2001:db8::10]"
    error_message = "A bracketed IPv6 literal should be accepted as the hostname."
  }
}

run "rejects_ipv6_hostname_with_port" {
  command = plan

  variables {
    hostname = "[2001:db8::10]:443"
  }

  expect_failures = [var.hostname]
}
