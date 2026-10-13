# Cómo correr Rojo (paso a paso)

Rojo sincroniza `src/` hacia Roblox Studio. El mundo (Workspace) NO lo administra Rojo.

## Una sola vez (primera vez en tu PC)

1. Instala **Rokit** (gestor de herramientas): https://github.com/rojo-rbx/rokit
2. En la raíz del repo, instala las herramientas del proyecto:
   ```
   rokit install
   ```
   Esto instala Rojo 7.7.1 (definido en `rokit.toml`).
3. Instala el **plugin de Rojo** en Studio:
   ```
   rojo plugin install
   ```
   Reinicia Studio si estaba abierto.

## Cada vez que trabajas

1. Actualiza el código y crea tu rama:
   ```
   git checkout main
   git pull
   git checkout -b feature/mi-tarea
   ```
2. Abre **TU PROPIO lugar de pruebas** en Roblox Studio (nunca el oficial mientras desarrollas).
3. En la terminal, en la raíz del repo, inicia el servidor:
   ```
   rojo serve
   ```
   Debe mostrar `Rojo server listening on localhost:34872`. Deja esa terminal abierta.
4. En Studio: pestaña **Plugins → Rojo → Connect** (puerto 34872 por defecto).
5. Edita archivos en `src/` y se reflejan en Studio al instante.
6. Prueba con **Play** en Studio y revisa la consola (Output).

## Al terminar

1. En Studio: **Rojo → Disconnect**. En la terminal: `Ctrl + C`.
2. Commit en español, push de la rama y Pull Request a `main`.

## Dónde cae cada carpeta

| Carpeta         | Destino en Studio                    |
|-----------------|--------------------------------------|
| `src/server/`   | ServerScriptService                  |
| `src/client/`   | StarterPlayer/StarterPlayerScripts   |
| `src/shared/`   | ReplicatedStorage                    |

## Problemas comunes

- **`rojo` no se reconoce**: cierra y abre la terminal, o corre `rokit install`.
- **El plugin no conecta**: confirma que `rojo serve` sigue corriendo y que el puerto es 34872.
- **No veo mis scripts**: no edites scripts en Studio; Rojo los sobrescribe. Solo en `src/`.
- **Lugar oficial**: solo recibe código de `main`. Quien integra hace `git pull`, conecta Rojo, sincroniza y desconecta.
