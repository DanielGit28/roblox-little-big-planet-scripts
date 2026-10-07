Roblox Piloto — Instrucciones del proyecto (compartidas)
El juego
Juego 2D lateral multijugador (1–8) inspirado en "Bomb Survival" (LittleBigPlanet).

Bombas caen desde una franja invisible arriba del mapa, en posiciones aleatorias; explotan al tocar
cualquier cosa y destruyen en un radio fijo.

Terreno de peluche por capas (pasto, tierra, tierra oscura). Cada capa es una pieza continua; las capas
NO están unidas entre sí y se desmoronan en escombros con física.

Objetos sueltos en la superficie (árbol, nube, carro).
Spawner: círculo brillante al centro, indestructible y sin colisión con jugadores, pero lo empujan las
explosiones y cae si pierde su piso. Los jugadores renacen donde esté.

3 vidas. Rondas sin límite de tiempo; la frecuencia de bombas sube. Victoria: llegar a la meta del fondo
o ser el último en pie (solo: meta o perder 3 vidas).

Estilo: peluche ligero (material Fabric, colores suaves, bordes redondeados).
Dónde vive cada cosa (MUY IMPORTANTE)
CÓDIGO: siempre como archivos en src/, sincronizados a Studio con Rojo y guardados en GitHub.
src/server/ → ServerScriptService (bombas, rondas, vidas, spawner).
src/client/ → StarterPlayer/StarterPlayerScripts (agarre, cámara, controles, UI).
src/shared/ → ReplicatedStorage (módulos compartidos, configuración).
NUNCA crees ni edites scripts directamente en Studio por MCP: Rojo los sobrescribe.
MUNDO (mapa, capas, objetos, materiales, imágenes): vive en la nube de Roblox, en Workspace.
Rojo NO administra Workspace. Carpetas: Workspace/Mapa/Capas, /Objetos, /Meta, /Spawner.

Arquitectura y estilo de código
Luau con --!strict cuando sea posible. Nombres en inglés; comentarios breves.
Decisiones del juego (daño, vidas, ganador) en el servidor; el cliente solo input, cámara y presentación.
Valores ajustables en src/shared/Config.luau.
Rendimiento: limitar escombros activos y limpiar los que salen del mapa.
Flujo de trabajo (ambos programan por igual)
git pull en main y una rama por tarea (ej. feature/agarre).
Cada persona conecta Rojo a SU PROPIO lugar de pruebas, nunca al oficial mientras desarrolla.
Tareas grandes: /spec → /plan → /build. Cambios pequeños, uno a la vez.
Probar en Studio (Play) y leer la consola por MCP antes de dar algo por terminado.
Commit en español, push de la rama y Pull Request a main; el otro revisa con /review.
El lugar OFICIAL solo recibe código de main: quien integra hace git pull, conecta Rojo, sincroniza y desconecta.
Las tareas se reparten en la reunión semanal para trabajar en archivos distintos.