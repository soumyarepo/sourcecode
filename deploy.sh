#!/bin/bash

# Set the path to the Kubernetesmanifests folder
MANIFESTS_FOLDER="kubernetesmanifests"

# Loop through each YAML file in the folder and apply it using kubectl
for file in "$MANIFESTS_FOLDER"/*.yaml; do
    kubectl apply -f "$file"
done