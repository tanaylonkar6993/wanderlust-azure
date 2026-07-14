resource "azurerm_resource_group" "wanderlust" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "wanderlust" {
  name                = "wanderlust-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.wanderlust.location
  resource_group_name = azurerm_resource_group.wanderlust.name
}

resource "azurerm_subnet" "wanderlust" {
  name                 = "wanderlust-subnet"
  resource_group_name  = azurerm_resource_group.wanderlust.name
  virtual_network_name = azurerm_virtual_network.wanderlust.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "allow_user_to_connect" {
  name                = "allow-tls"
  location            = azurerm_resource_group.wanderlust.location
  resource_group_name = azurerm_resource_group.wanderlust.name

  security_rule {
    name                       = "allow-ssh"
    description                = "port 22 allow"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    description                = "port 80 allow"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    description                = "port 443 allow"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-jenkins"
    description                = "port 8080 allow"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-sonarqube"
    description                = "port 9000 allow"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name = "mysecurity"
  }
}

resource "azurerm_public_ip" "wanderlust" {
  name                = "wanderlust-public-ip"
  location            = azurerm_resource_group.wanderlust.location
  resource_group_name = azurerm_resource_group.wanderlust.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "wanderlust" {
  name                = "wanderlust-nic"
  location            = azurerm_resource_group.wanderlust.location
  resource_group_name = azurerm_resource_group.wanderlust.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.wanderlust.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.wanderlust.id
  }
}

resource "azurerm_network_interface_security_group_association" "wanderlust" {
  network_interface_id      = azurerm_network_interface.wanderlust.id
  network_security_group_id = azurerm_network_security_group.allow_user_to_connect.id
}

resource "azurerm_linux_virtual_machine" "jenkins_master" {
  name                = "jenkins-master"
  resource_group_name = azurerm_resource_group.wanderlust.name
  location            = azurerm_resource_group.wanderlust.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.wanderlust.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand(var.ssh_public_key_path))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    Name = "jenkins-master"
  }
}
