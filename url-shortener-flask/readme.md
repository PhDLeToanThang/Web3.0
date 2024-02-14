Url Shortener (Flask)
This project is a simple url shortener developed with the python framework Flask.

It takes as input a valid url, then will create a link of size *domain name + 6 characters.

It has been designed to be self-hosted

Usage
Modification
The following two variables need to be modified:

BASE_URL = "http://localhost:5000/"
app.secret_key = 'mY-SeCRet-kEy'
The first represents the domain name of your application.

The second (optional modification) will be used to generate a security hash.

Demonstration
The first page of the application allows us to fill in the url that we want to shorten.

You can also find a history of the last links created.

Homepage

The second page simply references all the information about the new link created such as:

the old link
the new link
a ping of the old link
qrcode to the new link
Link