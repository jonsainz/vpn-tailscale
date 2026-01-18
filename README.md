# Hacer una VPN en linux con Tailscale y exit node


## Instrucciones

1) Tener instalado Tailscale.
2) Activar exit node

	sudo tailscale up --advertise-exit-node
- si te da error, Para que tu Fedora actúe como salida a internet para otros, debe permitir el reenvío de paquetes IP.

echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

luego vuelve a ejecutar sudo tailsclae...

2. Optimizar UDP GRO (El segundo aviso)

Esto no es obligatorio para que funcione, pero hará que tu conexión sea mucho más rápida. Se trata de cómo la tarjeta de red maneja los paquetes de datos.

Para arreglarlo en tu interfaz wlp0s26u1u5, ejecuta:
Bash

sudo ethtool -K wlp0s26u1u5 rx-udp-gro-forwarding on

Nota: Si quieres que esto sea permanente, Tailscale recomienda crear un servicio de systemd o una regla de udev, pero prueba primero el comando de arriba para ver si el aviso desaparece.

4. ¡Paso importante en Fedora! (Firewall)

Fedora usa firewalld de forma estricta. Si después de lo anterior tus dispositivos no pueden navegar, es probable que el firewall esté bloqueando el tráfico. Prueba a permitir el enmascaramiento:
Bash

sudo firewall-cmd --permanent --add-masquerade
sudo firewall-cmd --reload

¿Qué sigue ahora? Una vez que el comando no te dé errores, recuerda que debes ir al Admin Console de Tailscale (en la web), buscar tu máquina Fedora y, en el menú de "Edit route settings", marcar la casilla para aprobar el Exit Node.





Esto le dice a Tailscale:

“Este equipo puede usarse como salida a Internet”.

Nota:
	•	No cambia nada todavía
	•	No afecta a tu red

3) Autorizar el Exit Node

- https://login.tailscale.com/admin/machines
- Busca mi PC Linux
- Activa: Use a exit node

4) Utilizar Exit Node desde otrondispositivo

- Otro PC:
	tailscale up --exit-node=NOMBRE_DEL_PC

(Para usar también DNS y todo el tráfi)
	tailscale up --exit-node=NOMBRE_DEL_PC --exit-node-allow-lan-access

- En el movil: en la App tailscale / Exit Node / selecionar PC Linux / Activar

5) Comprobar

- En el dispositivo cliente: 
	https://ipinfo.io

(deberia salir la IP de mi casa no la wifi publica)

