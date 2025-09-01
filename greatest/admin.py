from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustUser
# Register your models here.
admin.site.register(CustUser, UserAdmin)