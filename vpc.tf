resource "aws_vpc" "demo-vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "${var.vpc_name}"
    }
}

resource "aws_internet_gateway" "demo-igw" {
    vpc_id = "${aws_vpc.demo-vpc.id}"
	tags {
		Name = "${var.igw_name}"
	}
}


/*
  Public Subnets
*/
resource "aws_subnet" "demo-public1" {
    vpc_id = "${aws_vpc.demo-vpc.id}"

    cidr_block = "${var.public_subnet1_cidr}"
    availability_zone = "${var.az_1}"

    tags {
        Name = "${var.public_subnet1_name}"
    }
}

resource "aws_subnet" "demo-public2"{
    vpc_id = "${aws_vpc.demo-vpc.id}"

    cidr_block = "${var.public_subnet2_cidr}"
    availability_zone = "${var.az_2}"

    tags {
        Name = "${var.public_subnet2_name}"
    }
}

resource "aws_route_table" "demo-pub-rt"{
    vpc_id = "${aws_vpc.demo-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.demo-igw.id}"
    }

    tags {
        Name = "${var.public_RT}"
    }
}

resource "aws_route_table_association" "demo-pub-rt1" {
    subnet_id = "${aws_subnet.demo-public1.id}"
    route_table_id = "${aws_route_table.demo-pub-rt.id}"
}

resource "aws_route_table_association" "demo-pub-rt2" {
    subnet_id = "${aws_subnet.demo-public2.id}"
    route_table_id = "${aws_route_table.demo-pub-rt.id}"
}

/*
NAT Gateway
*/

resource "aws_eip" "demo-nat-ip" {
    vpc      = true
}
resource "aws_nat_gateway" "demo-nat" {
    allocation_id = "${aws_eip.demo-nat-ip.id}"
    subnet_id = "${aws_subnet.demo-public1.id}"
    depends_on = ["aws_internet_gateway.demo-igw"]
	tags {
		Nmae = "${var.nat_name}"
	}
}


/*
  Private Subnet
*/
resource "aws_subnet" "demo-private1" {
    vpc_id = "${aws_vpc.demo-vpc.id}"

    cidr_block = "${var.private_subnet1_cidr}"
    availability_zone = "${var.az_1}"

    tags {
        Name = "${var.private_subnet1_name}"
    }
}

resource "aws_subnet" "demo-private2" {
    vpc_id = "${aws_vpc.demo-vpc.id}"

    cidr_block = "${var.private_subnet2_cidr}"
    availability_zone = "${var.az_2}"

    tags {
        Name = "${var.private_subnet2_name}"
    }
}

resource "aws_route_table" "demo-pri-rt"{
    vpc_id = "${aws_vpc.demo-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.demo-nat.id}"
    }

    tags {
        Name = "${var.private_RT}"
    }
}

resource "aws_route_table_association" "demo-pri-rt1" {
    subnet_id = "${aws_subnet.demo-private1.id}"
    route_table_id = "${aws_route_table.demo-pri-rt.id}"
}

resource "aws_route_table_association" "demo-pri-rt2" {
    subnet_id = "${aws_subnet.demo-private2.id}"
    route_table_id = "${aws_route_table.demo-pri-rt.id}"
}



