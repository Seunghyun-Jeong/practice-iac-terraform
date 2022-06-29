resource "aws_db_subnet_group" "sprint-sg" {
  name = "test"
  subnet_ids = [ 
    aws_subnet.private_subnet.id,
    aws_subnet.private_subnet2.id
  ]
}
resource "aws_db_instance" "sprint-db" {
  allocated_storage = 20
  engine = "mysql"
  engine_version = "8.0.28"
  instance_class = "db.t2.micro"
  username = "admin123"
  password = "admin123"
  db_subnet_group_name = aws_db_subnet_group.sprint-sg.name
  vpc_security_group_ids = [ 
    aws_security_group.private-SG.id,
   ]
  skip_final_snapshot = true
  }