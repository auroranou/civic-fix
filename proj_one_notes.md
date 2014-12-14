##Models: 
1. Users
2. Posts
3. Messages
4. Organizations

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