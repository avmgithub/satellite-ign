
variable "ibmcloud_api_key" {
  type = string
}

variable "host_details" {
  description = "IP addresses from subnet"
  type = list(
    object(
      {
        ip_addr   = string
        hostname  = string
      }
    )
  )
  default = [
    {
      ip_addr    = "10.241.64.4",
      hostname   = "hostname2"
    }, 
    { 
      ip_addr    = "10.241.64.5",
      hostname   = "hostname3"
    }, 
    { 
      ip_addr    = "10.241.64.6",
      hostname   = "hostname4"
    }, 
    {
      ip_addr    = "10.241.64.7",
      hostname   = "hostname5"
    } 
  ]
}
