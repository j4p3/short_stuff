import json
from os import getenv, path
from string import Template
from subprocess import run
from sys import exit


ZONE_ID = getenv("ZONE_ID")
ZONE_FILE = getenv("ZONE_FILE")
TERRAFORM_DIR = getenv("TERRAFORM_DIR")

# Returns the variable key if not present in ENV.
def check_env_vars():
    if not ZONE_FILE:
        return "$ZONE_FILE"
    if not ZONE_ID:
        return "$ZONE_ID"
    if not TERRAFORM_DIR:
        return "$TERRAFORM_DIR"
    return ""


# Loads the zone records in a dict
def load_records(zone_file=ZONE_FILE):
    with open(zone_file) as record_file:
        data = json.load(record_file)
    return data


# Writes the dummy Terraform template which is required
# before `terraform import` runs.
def template_dummy_file(resource_name):
    print(f"creating dummy record for {resource_name}")
    add_dummy_record = Template(
        """
	resource "aws_route53_record" "$resource_name" {
	# (resource arguments)
	}
	"""
    )
    dummy_file_path = path.join(TERRAFORM_DIR, "dns.tf")
    with open(dummy_file_path, "a") as f:
        f.write(add_dummy_record.substitute(resource_name=resource_name))


# Shells out `terraform import` command in the host OS.
def terraform_import(resource_name, resource_type):
    print(f"importing resource {resource_name}")
    resource_name = resource_name.replace(".", "")
    import_command = f"terraform import -config={TERRAFORM_DIR} -var=file={TERRAFORM_DIR}/environment/dev.tfvars aws_route53_record.{resource_name} {ZONE_ID}_{resource_name}_{resource_type}"
    print(f"running command {import_command}")
    run(import_command, shell=True, check=True)

if __name__ == "__main__":
    missing = check_env_vars()
    if missing:
        exit(f"Required env variable {missing} is missing.")
    print("running")
    records = load_records()
    print("loaded records")
    for i in records.get("ResourceRecordSets"):
        resource_name = i.get("Name")
        resource_type = i.get("Type")
        print(f"processing record {resource_name}")
        template_dummy_file(resource_name)
        terraform_import(resource_name, resource_type)
        print(f"Imported {resource_name}")
