"""
URL configuration for ammentor_backend project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.http import JsonResponse
from django.http import HttpResponse

def healthcheck(request):
    return JsonResponse({"status": "ok"})
def nothingtosee(request):
    image_url = "https://i.imgflip.com/9s22un.jpg"

    html_content = f"""
    <html>
    <head><title>Nothing to See Here</title></head>
    <body style="text-align: center;">
        <img src="{image_url}" alt="Sad Pablo Meme" style="width:50%; margin-top:20px; border-radius: 12px;">
    </body>
    </html>
    """
    return HttpResponse(html_content)
urlpatterns = [
    path('health/', healthcheck),
    path('', nothingtosee, name='landing'), 
    path('admin/', admin.site.urls),
    path('curriculum/', include('curriculum.urls')), 
    path('members/', include('members.urls')),
    path('badges/', include('badges.urls')),

]+static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
