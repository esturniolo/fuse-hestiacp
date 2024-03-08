# Notas de instalación


### Infra

El setup está hecho con Cloudflare que es quién tiene los registros correspondientes y maneja los certificados SSL en modo estricto.

![image](hestia-Infra.png)

---
### Instalación

El [instalador](https://hestiacp.com/install.html) es simple y hace lo que dice, solo hay que tener en cuenta algunas cosas a la hora de comenzar a usarlo.

Para instalarlo me ayudé con estos recursos:

https://www.youtube.com/watch?v=BK7qyPa-VmI

https://ideaspot.com.au/blog/cloudflare-hestia-setup/

Además de esto, parece que este usuario tiene varias cosas referidas a Hestia, por lo que podría ser una fuente de consulta.

---

### Issues

Tuve algunos problemas como por ejemplo:
- No podía entrar a phpMyAdmin `Error Existing configuration file (/etc/phpmyadmin/config.inc.php) is not readable`

  Fix: 
```
chown -R root:www-data /etc/phpmyadmin/
chown -R hestiamail:www-data /usr/share/phpmyadmin/tmp/
```
[Fuente](https://forum.hestiacp.com/t/error-existing-configuration-file-etc-phpmyadmin-config-inc-php-is-not-readable/12096)

- No tenía los permisos correctos en los ficheros y directorios que subía (me pasó con WP, pero aplica a cualquier fichero)

Fix:

```
cd /home/bob/web/mysite.com/public_html 
# double check you're in the right directory! 
chown -R bob:bob * 
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
```

[Fuente](https://forum.hestiacp.com/t/wordpress-permissions-folders/3565)

