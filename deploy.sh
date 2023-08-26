#!/bin/bash

# Set the path to the Kubernetesmanifests folder
MANIFESTS_FOLDER="/home/ubuntu/jenkins/workspace/multibranch-pipeline_main/Kubernetesmanifests"

# Loop through each YAML file in the folder and apply it using kubectl
for file in "$MANIFESTS_FOLDER"/*.yaml; do
    kubectl apply -f "$file"
done