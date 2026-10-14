# Dirección de arte — Bomb Survival (peluche)

Aplica estas reglas SIEMPRE que construyas o modifiques algo visual (mapa, props, luz, efectos).
Si una petición choca con estas reglas, avísame antes de romperlas.

## 1. Visión en una frase
Un mundo de juguetes de peluche, cálido y alegre, que se ve "acolchonado" y tierno, para que destruirlo
con bombas sea divertido por contraste. Referencia: dioramas de fieltro y LittleBigPlanet (sin copiar assets).

## 2. Composición para cámara 2D lateral (lo más importante)
El jugador ve el mundo DE LADO. Todo se diseña para esa vista:
- **Plano de juego (Z = 0):** terreno destructible, spawner, meta, props interactivos. Colores más
  saturados y contrastados. Es lo que el jugador debe leer al instante.
- **Fondo cercano (Z = -20 a -40):** colinas de peluche, árboles grandes, casitas. Anclados,
  CanCollide = false, CanQuery = false, CastShadow = false. Algo menos saturados.
- **Fondo lejano (Z = -80 a -200):** montañas suaves, nubes grandes. Muy desaturados y claros; la
  Atmosphere los "funde" con el cielo. Crean profundidad (efecto parallax al moverse la cámara).
- **Primer plano opcional (Z = +10 a +15):** pocas plantas o pasto alto en los bordes inferiores,
  translúcidos o pequeños, que NUNCA tapen al jugador ni a las bombas.
- No pongas detalle donde la cámara no llega (detrás de los fondos, debajo del mapa).
- Los fondos y el primer plano NO interactúan con bombas ni jugadores (solo decoración).

## 3. Paleta (3–5 colores base + acentos)
Base (usar variaciones de tono de estos, no colores nuevos):
- Pasto: verde manzana `#7BC96F` (variantes `#6AB85E`, `#8FD982`)
- Tierra: caramelo `#B9814F` (variantes `#A8723F`, `#C9925F`)
- Tierra profunda: chocolate `#6B4636` (variante `#5A3A2D`)
- Cielo/fondos: crema y lavanda suaves `#F6E7D7`, `#C9C3E6`
Acentos (solo para lo que el jugador DEBE ver):
- Spawner: amarillo cálido brillante `#FFD45C` con luz
- Meta: menta `#5FE0C1` con brillo suave
- Bombas: negro `#2B2B2B` con detalles rojo `#E04A3F` (máximo contraste del juego)
Reglas:
- Nada de colores puros (255,0,0) ni neón en superficies grandes.
- Prueba del desenfoque: si al difuminar una captura los colores se funden en un conjunto armónico,
  la paleta funciona.
- Varía ligeramente el color de piezas repetidas (±5–10% de brillo) para que no se vean clonadas.

## 4. Materiales y formas "peluche"
- Material principal: **Fabric**. SmoothPlastic solo para detalles pequeños (botones, ojos).
- Formas redondeadas: bordes con cilindros/esferas, nada de esquinas afiladas en props.
  Árboles = copas de esferas aplastadas; nubes = racimos de esferas; carro = cuerpo redondeado con ruedas grandes.
- Proporciones exageradas y "tiernas": props un poco más gordos y bajos de lo real, ruedas y botones grandes.
- Detalles de peluche: costuras (Texture/Decal de puntadas en bordes), botones, parches de otro tono,
  pequeñas etiquetas. Pocos pero bien colocados.
- Usa un muñeco (Dummy R15) como referencia de escala: el jugador debe caber cómodo en los huecos.

## 5. Iluminación (valores iniciales; ajustar mirando capturas)
Lighting:
- LightingStyle = Realistic, ShadowSoftness = 0.6, GlobalShadows = true
- ClockTime = 15.5 (tarde cálida), Brightness = 2.5
- Ambient = [90, 80, 95], OutdoorAmbient = [175, 160, 150]
- EnvironmentDiffuseScale = 1, EnvironmentSpecularScale = 0.2 (la tela no brilla)
- ColorShift_Top = [255, 235, 210] (sol cálido)
Atmosphere: Density = 0.3, Offset = 0.25, Haze = 1.5, Color = [255, 230, 220], Glare = 0.2, Decay = [200, 170, 220]
BloomEffect: Intensity = 0.6, Size = 24, Threshold = 1.3 (solo brillan spawner, meta y explosiones)
ColorCorrectionEffect: Saturation = 0.15, Contrast = 0.08, Brightness = 0.02, TintColor = [255, 250, 245]
SunRaysEffect: Intensity = 0.04, Spread = 0.6
Sky: cielo de tonos pastel (no el cielo azul por defecto).
- Luces puntuales solo donde importan (spawner, meta); Shadows = false en luces pequeñas.

## 6. Legibilidad del juego (prioridad sobre la belleza)
- El jugador, las bombas y el spawner deben distinguirse en 0,5 s, incluso en un teléfono.
- Valores de contraste: plano de juego más oscuro/saturado que el fondo; bombas las más oscuras.
- Cada capa de terreno con un tono claramente distinto, para que se lea la profundidad al romperse.
- Revisa siempre cómo se ve en el emulador de teléfono (Test → Device).

## 7. Detalle con criterio
- "Más detalle" = variación y capas, no saturar. Densidad media: zonas de descanso visual entre grupos.
- Agrupa props en pequeñas composiciones (árbol + arbusto + flores) en vez de piezas sueltas en fila.
- Reutiliza modelos (un árbol bien hecho) y varíalos en escala (0.8–1.3), rotación y tono.
- Partículas sutiles de ambiente: pelusitas o semillas flotando (pocas, lentas).

## 8. Rendimiento (Roblox se juega mucho en teléfono)
- Decoración: Anchored = true, CanCollide = false, CanTouch = false, CanQuery = false, CastShadow = false si es pequeña.
- Prefiere menos piezas más grandes; agrupa en Models con nombres claros.
- Nada de luces con sombra en props repetidos. Pocas partículas.
- Revisa con Shift+F3 (rendimiento) que el mapa no baje de FPS.

## 9. Organización en el Explorer
Workspace/Mapa/Capas, Workspace/Mapa/Objetos, Workspace/Mapa/Meta, Workspace/Mapa/Spawner,
Workspace/Fondo/Cercano, Workspace/Fondo/Lejano, Workspace/PrimerPlano.
Nombres en español y descriptivos (ej. "Arbol_Grande_01").

## 10. Cómo trabajar conmigo en lo visual
- Antes de construir algo grande, descríbeme en 3–4 líneas la composición que propones.
- Construye por pasos: primero formas y colores, luego luz, luego detalles.
- Cuando te mande una captura de pantalla, critícala contra esta guía (composición, paleta, legibilidad)
  y propón 3 mejoras concretas antes de cambiar nada.
- La lógica (explosiones, partículas de bomba, movimiento) es código en `src/`; aquí solo lo visual estático.
