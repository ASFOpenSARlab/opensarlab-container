
import argparse

import boto3

def main(image_name, aws_region, container_namespace, aws_profile):
    
    if not image_name.isalnum():
        raise ValueError(f"{image_name} is not pure alphanumeric.")

    session = None 
    try:
        session = boto3.session.Session(region_name=aws_region, profile_name=aws_profile)
    except:
        session = boto3.session.Session(region_name=aws_region)

    ecr = session.client('ecr')

    repositoryName=f"{container_namespace}/{image_name}"

    try:
        response = ecr.describe_repositories(repositoryNames=[repositoryName])
        print(f"Repo '{repositoryName}' already exists.")
    except ecr.exception.RepositoryNotFoundException as e:
        print(f"Repo for {repositoryName} not found. Creating...")
        response = ecr.create_repository(repositoryName=repositoryName)


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument('--image_name', default=None)
    parser.add_argument('--aws_profile', default=None)
    parser.add_argument('--aws_region', default=None)
    parser.add_argument('--container_namespace', default=None)
    args = parser.parse_args()

    main(args.image_name, args.aws_region, args.container_namespace, args.aws_profile)