##############################################################
# Settings for Service Principal Account and Azure Resources #
##############################################################

variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "subscription_id" {}

#####################################
# Variables for resource deployment #
#####################################

# Name of the resource group
variable "resource_group" {}

# Deployment region, Location of the Azure resource group and services
variable "region" {}
