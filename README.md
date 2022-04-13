## Setup

clone beta branch `https://github.com/banyansecurity/terraform-provider-banyan/tree/beta`

cd to the downloaded and checked out directory

run `make install`

this installs the provider beta version locally

change back to this projects directory

ensure you have exported your aws credentials (select programmatic access after aws login from okta) and have a TEAM EDITION org with an admin api key 

change `locals.tf` variables to match your AWS configuration
#### Example 
```hcl
locals {
  region = "us-west-2"
  name = "SOME NAME HERE"
  banyan_api_key = "ADMIN API KEY (created on your own)"
  connector_api_key = "BANYAN CONNECTOR API KEY (given at first login to team edition)"
  banyan_host = "https://team.console.banyanops.com/"
  key_name   = "WHATEVER KEY NAME YOU WANT TO CREATE"
  public_key = "your public key i.e. ~/.ssh/id_rsa.pub"
}
```

## Usage

run `terraform apply`

this should result in a public and private subnet with a banyan connector in the public subnet and an instance with a demo web service and ssh service appearing in the console for everyone in the org