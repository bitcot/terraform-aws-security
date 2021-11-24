variable "stack" {
    type = string
    description = "Defines the application stack to which this component is related. (e.g AirView, PivotalCloud, Exchange)"
}
variable "access_key" {
    type = string
    description = " Enter access_key"
}
variable "secret_key" {
    type = string
    description = "Enter secret_key"
}
variable "region_primary" {
    type = string
    description = "Primary AWS region for this account"
}