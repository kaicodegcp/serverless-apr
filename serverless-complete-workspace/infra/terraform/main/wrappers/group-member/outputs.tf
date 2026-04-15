output "id" {
  description = "The ID of the group membership"
  value       = module.group_member.id
}

output "group_id" {
  description = "The group ID"
  value       = module.group_member.group_id
}

output "member_id" {
  description = "The member ID"
  value       = module.group_member.member_id
}
