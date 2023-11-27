output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.MyVPC.id
}
output "public_subnet1" {
  description = "PUBLIC SUBNET1"
  value = aws_subnet.PublicSubnetA1.id
}
output "public_subnet2" {
  description = "PUBLIC SUBNET2"
  value = aws_subnet.PublicSubnetB1.id
}
output "private_subnet1" {
  description = "PRIVATE SUBNET1"
  value = aws_subnet.PrivateSubnetA2.id
}
output "private_subnet2" {
  description = "PRIVATE SUBNET2"
  value = aws_subnet.PrivateSubnetB2.id
}