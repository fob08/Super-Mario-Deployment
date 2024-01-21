variable "my_access_key" {
    description = "This is meant to store the access key used to access the aws platform"
    type = string
}

variable "my_secret_key" {
    description = "This is meant to store the access key used to access the aws platform"
    type = string
}

variable "server_port" {
    description = "the port the server will use for HTTP requests"
    type = number
    default = 8080
}

variable "client_port" {
    description = "the port the server will use for HTTP requests"
    type = number
    default = 20
}