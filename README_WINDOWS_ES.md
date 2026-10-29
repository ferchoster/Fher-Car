# FERCHOSTER CAR — inicio limpio

Proyecto base para iPhone 6 / iOS 12.5.7, pensado para una interfaz horizontal azul marino y gris para CarBridge.

## Importante
- Esta primera entrega es una base visual y de compilación, no una integración con la electrónica del Hyundai.
- Los botones de radio AM/FM y climatización son demostrativos; requieren hardware/protocolo compatible para controlar funciones reales.
- Se compila en Codemagic con macOS; no se necesita Mac local.
- La instalación de un IPA sin firma puede depender del jailbreak, AppSync Unified y de que el paquete esté correctamente construido. No se garantiza la instalación.

## Repositorio
Sube el contenido de este ZIP a la raíz del repositorio GitHub `ferchoster/Fher-Car`.

## Compilar en Codemagic
1. Conecta el repositorio `Fher-Car` a Codemagic.
2. Selecciona el archivo `codemagic.yaml`.
3. Inicia el workflow `FERCHOSTER CAR iOS`.
4. Descarga el artefacto `FERCHOSTER_CAR_unsigned.ipa` si la compilación termina correctamente.

## Nota sobre el esquema Xcode
El proyecto Xcode debe contener un target y un scheme llamado `FERCHOSTER_CAR`. Esta entrega incluye archivos fuente y YAML; si el build informa que no encuentra `FERCHOSTER_CAR.xcodeproj` o el scheme, abre el proyecto en un Mac/Xcode o ajusta el workflow para generar/usar el proyecto Xcode correcto. El ZIP actual es un esqueleto fuente y configuración; no contiene un `.pbxproj` completo generado por Xcode.
