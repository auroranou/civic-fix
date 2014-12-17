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

-----

##Views:
1. Homepage (get)

Links to sign up, log in
Running feed of user-generated messages (PSAs)

2. Sign up page (get, post)

Form containing fields for name, email, password, password confirmation

Redirect to user dashboard

3. Log in page (get, post)

Form containing fields for email, password

Redirect to user dashboard

4. User dashboard (get)

Lists of all past messages and posts
Links to post new PSA or write new message
Link to log out

5. Message form (get, post)

Form containing fields for user email, receiver email, message body

Redirect to user dashboard

6. PSA form (get, post)

Form containing fields for title, description

Redirect to homepage

7. Logout page

Redirect to homepage


-----
TO DO
X- show homepage feeds in order by most recent
X- change post update to update description only, add "UPDATED" to post title
X- show poster in index view
- show follow up address, phone in messages feed
X- fix footer alignment
X- change textarea height
X- finish seeding organization database
X- deploy
X- integrate heroku mail add-on
X- change form width on sign in/log in
- implement infinite scroll?
X- favicon
- error alerts



