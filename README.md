# Hacer una VPN en linux con Tailscale y exit node


## Instrucciones

1) Tener instalado Tailscale.
2) Activar exit node

	sudo tailscale up --advertise-exit-node

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

