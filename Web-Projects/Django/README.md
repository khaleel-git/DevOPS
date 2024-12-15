## Django installing
install python
pip install djanto

django-admin startproject mysite
create a skeleton of django app
it will create mysite folder including skeleton project configuration

mysite -> urls.py
# serve the content of mysite application

# now start the application
python manage.py startapp mysite-app

# create template folder and place index.html file inside it

# edit views.py and add below lines
```python
from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.
def index(request):
    return render(request, 'index.html') # place in atemplate folder
```

# apply changings
python manage.py migrate

# run django app
python manage.py runserver
