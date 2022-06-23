# RDS Postgres subnet group
resource "aws_db_subnet_group" "database-subnet-group" {
  name         = "database subnets"
  subnet_ids = [
      aws_subnet.private_1.id,
      aws_subnet.private_2.id,
    ]
  description  = "Subnets for Database Instance"

  tags   = {
    Name = "Database Subnets"
  }
}


resource "aws_db_instance" "postgres" {
  
  allocated_storage    = 10
  engine               = var.db_engine
  # engine_version       = "5.7"
  instance_class       = var.db_instance_class
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  db_name               = var.db_name
  db_subnet_group_name = aws_db_subnet_group.database-subnet-group.name
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  vpc_security_group_ids = [ aws_security_group.allow-tcp.id ]
}


resource "aws_security_group_rule" "db-security-group-rule-allow-all" {
  description              = "Allow all communication from eks nodes"
  from_port                = 0
  protocol                 =  "tcp"
  security_group_id        = aws_security_group.allow-tcp.id
  to_port                  = 65535
  type                     = "ingress"
  source_security_group_id  = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group" "allow-tcp" {
  name        = "allow-tcp"
  description = "Allow Tcp inbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "security group db"
  }
}

resource "aws_security_group_rule" "outgoing" {
  description              = "Allow all outgoing"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.allow-tcp.id
  cidr_blocks              = [aws_vpc.main.cidr_block]
  to_port                  = 0
  type                     = "egress"
}