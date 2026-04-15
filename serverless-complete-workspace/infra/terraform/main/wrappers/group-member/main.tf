# Wrapper: group-member
module "group_member" {
  source = "../../modules/group-member"

  group_id = var.group_id
  member_id = var.member_id
}
