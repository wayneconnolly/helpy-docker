
# Note: this is old and other better alternatives now exist.

Dockerise Helpy: A Modern Helpdesk Alternative
====================================

To Dockerise Helpy you must make a few tweaks to the source code also there are a couple of things to note.

- Nginx will be exposed on ports 80 443. if you want to put a SSL cert on 443 then there are plenty of resources out there to help you so I wil let you google that.
- This method assumes that nothing eles is running on port 80. If you do have something on port 80 then you can simply comment out the nginx components, expose port 3000 and then use the nginx-sites.conf for your new vhost.

### Clone/copy a fresh copy of Helpy
cd into where you placed the Dockerfile and clone the latest helpy into a directory called "helpy" or copy your existing application there.

    git clone git@github.com:scott/helpy.git helpy

### Set the application to production mode

config/environment.rb: Add the following to Line 3:
 
     ENV['RAILS_ENV'] = 'production'

### Helpy users and passwords
db/seeds.rb: Edit the users and the users passwords that you need. Remove any you don't need.



### Secure the secrets_key
config/initializers: Line 22:
Change the config.secret_key


- Docker : install it.
[http://www.docker.com/](http://www.docker.com/)



### Update the database
Don't forget to create a new password for yourself and replace "**helpy1234**"

config/database.yml: with
    	

    production:
        	   url: postgres://helpy:helpy1234@postgres/helpy_production

or 

	production:
	  adapter: postgresql
	  encoding: utf8
	  database: helpy_production
	  pool: 5
	  username: helpy
	  password: helpy1234
	  host: postgres  


### Postgres Docker
You need to set up postgres. This will sort you out. You have to secure the db files yourself.

- Make a local folder for postgres data persistance `/data/helpy/postgresql`
- Run this below command and make sure that you set a secure password and replace the "**helpy1234**". Use the same one as above in the database.yml file
- `docker run --name "postgres" -d -e 'DB_USER=helpy' -e 'DB_PASS=helpy1234' -e 'DB_NAME=helpy_production' -v /data/helpy/postgresql:/var/lib/postgresql quay.io/sameersbn/postgresql:9.4-7`


### Helpy Docker
CD into where the helpy Dockerfile is and run the below commands on the server

- `docker build --rm -t helpy .`
- `docker run -d -p 80:80 -p 443:443 --link postgres:postgres --name "helpy" helpy`


### Confirm the docker containers are up
- `docker ps` 
Shell into the Docker Helpy container to check that everything is running ok
- `docker exec -it helpy bash`

### Test the application
Visit the server IP in your browser and Helpy should load.


