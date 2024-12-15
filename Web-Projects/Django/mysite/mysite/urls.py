from django.contrib import admin
from django.urls import path
from mysite_app import views

urlpatterns = [
    path('admin/', admin.site.urls),  # Admin page
    path('', views.index, name='index'),  # Home page
]
