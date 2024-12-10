#!/bin/bash
az group create --name "INT-8167" --location "uksouth"
az role assignment create --role "Contributor" --assignee "179739d8-3be8-4ad7-99ea-57016def447e" --scope "/subscriptions/a2e585b2-2fd8-4371-ab02-639aafb9dcf1/resourceGroups/INT-8167"