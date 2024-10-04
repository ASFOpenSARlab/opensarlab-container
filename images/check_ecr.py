
import argparse
import sys

import boto3

def main(image_name:str, aws_region:str, container_namespace:str, aws_profile):

    if not image_name.isalnum():
        raise ValueError(f"{image_name} is not pure alphanumeric.")

    session = None 
    try:
        session = boto3.Session(region_name=aws_region, profile_name=aws_profile)
    except:
        session = boto3.Session(region_name=aws_region)

    ecr = session.client('ecr')

    try:
        repositoryName=f"{container_namespace}/{image_name}"
        _ = ecr.describe_repositories(repositoryNames=[repositoryName])
        print(f"Repo '{repositoryName}' already exists.")
    except ecr.exceptions.RepositoryNotFoundException as e:
        print(f"Repo for {repositoryName} not found. Creating...")
        _ = ecr.create_repository(repositoryName=repositoryName)


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument('--image_name', default=None)
    parser.add_argument('--aws_profile', default=None)
    parser.add_argument('--aws_region', default=None)
    parser.add_argument('--container_namespace', default=None)
    args = parser.parse_args()

    try:
        main(args.image_name, args.aws_region, args.container_namespace, args.aws_profile)
    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(-1)
