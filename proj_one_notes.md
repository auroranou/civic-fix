##Models and attributes: 
###Users:
- name 
- email
- password

###Posts:
- user_id
- title
- description

###Messages
- user_id
- mail_to
- mail_from (= user email)
- body

###Organizations
- org_name
- email
- phone
- address
- contact_name (optional)

-----

##Associations:
###Users:
- Have many posts
- Have many messages
- Have many organizations, through messages

###Posts:
- Belong to user

###Messages:
- Belong to user
- Have one organization

###Organizations:
- Have many messages
- Have many users, through messages

##To Do:
1. 