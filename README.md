## setup

change `main.tf` locals to match your api key and ssh key

run `terraform apply`

this should result in a new vpc with a public and private subnet with a banyan connector in the public subnet and an instance with a demo web service and ssh service appearing in the console for everyone in the org