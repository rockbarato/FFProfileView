FFProfileView
===============

![Image](http://cl.ly/image/1G232U0C0T2E/Mockup.jpg)
Un UIViewController que contiene una vista para las imágenes de perfil de usuario.

También tienes la opción de marcar una imagen por defecto, elegir una foto de la galería o bien tomar una foto con la cámara.

## Cambiando los valores por defecto

Puedes cambiar los valores por defecto como el key donde se guarda la imagen, el nombre de la imagen y la duración del efecto. de la siguiente manera:

``` objective-c
#define kImagePreferenceKey @"avatar-profile"
#define kDefaultProfileImage @"baby"
#define kAnimationDuration 0.5f
```

## Licencia

FFProfileView está disponible bajo la licencia [WTFPL (Do What the Fuck You Want to Public License)](http://www.wtfpl.net/about/). Veáse el archivo LICENSE para más información.

![WTFPL License](http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-2.png)
