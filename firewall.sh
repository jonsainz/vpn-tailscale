echo "🛠️ Aplicando configuración maestra para Exit Node en Fedora..."

# 1. Asegurar IP Forwarding a nivel de Kernel (Persistente)
echo "1. Configurando reenvío de paquetes (Kernel)..."
sudo tee /etc/sysctl.d/99-tailscale.conf <<INTERNAL_EOF
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
INTERNAL_EOF
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

# 2. Limpiar Firewalld y archivos corruptos
echo "2. Reiniciando y limpiando Firewall..."
sudo rm -f /etc/firewalld/direct.xml
sudo systemctl restart firewalld

# 3. Configuración de Zonas (El método más efectivo)
echo "3. Configurando zonas de confianza y enmascaramiento..."

# Eliminar tailscale0 de cualquier otra zona para evitar conflictos
sudo firewall-cmd --permanent --zone=public --remove-interface=tailscale0 2>/dev/null

# Añadir tailscale0 a la zona 'trusted' (esto permite que el tráfico entre sin trabas)
sudo firewall-cmd --permanent --zone=trusted --add-interface=tailscale0

# Activar el enmascaramiento en la zona 'public' (la que tiene tu internet)
sudo firewall-cmd --permanent --zone=public --add-masquerade

# 4. Crear Política de flujo entre zonas
echo "4. Creando política de paso entre Trusted y Public..."
sudo firewall-cmd --permanent --new-policy tailscaleAllowAll 2>/dev/null || echo "La política ya existe."
sudo firewall-cmd --permanent --policy tailscaleAllowAll --add-ingress-zone trusted
sudo firewall-cmd --permanent --policy tailscaleAllowAll --add-egress-zone public
sudo firewall-cmd --permanent --policy tailscaleAllowAll --set-target ACCEPT

# 5. Aplicar todo
echo "5. Aplicando cambios finales..."
sudo firewall-cmd --reload

# 6. Reiniciar Tailscale con el anuncio de Exit Node
sudo tailscale up --advertise-exit-node --reset

echo "-------------------------------------------------------"
echo "✅ ¡PROCESO COMPLETADO!"
echo "1. Asegúrate de que en el panel web de Tailscale el Exit Node esté 'Approved'."
echo "2. En tu móvil, activa el Exit Node."
echo "3. Si sigue sin cargar webs, prueba a entrar en http://1.1.1.1"
echo "   - Si 1.1.1.1 CARGA pero Google NO: Es un problema de DNS en el panel de Tailscale."
echo "   - Si NADA carga: Reinicia tu Fedora una vez."
echo "-------------------------------------------------------"
EOF


