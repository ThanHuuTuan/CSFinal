from django.conf.urls import url 
from . import views 

urlpatterns = [
        url(r"^$", views.messages, name="messages"),
        url(r"^purge$", views.requestPurge, name="purge"),
        url(r"^volandpos", views.VolAndPos, name="volandpos"),
        url(r"^uvol", views.uservol, name="uservol"),
        url(r"getc", views.getc, name="getc")
    ]

