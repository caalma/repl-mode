# repl-mode

`repl-mode` es un modo interactivo para Emacs que simula un REPL (Read-Eval-Print Loop) utilizando un ejecutable externo. Permite evaluar líneas de código o texto seleccionado, mostrar los resultados en el buffer actual y personalizar el comportamiento.


## Características principales

- **Evaluación flexible**: Evalúa líneas individuales o bloques de texto seleccionados.
- **Soporte para múltiples ejecutables**: Funciona con cualquier ejecutable que pueda procesar entrada estándar o argumentos.
- **Historial de evaluaciones**: Opcionalmente, duplica las líneas evaluadas para mantener un historial.
- **Personalización avanzada**:
  - Controla si el input se pasa por `stdin` o como argumentos.
  - Decide si el input debe ser encomillado automáticamente.
  - Elimina espacios innecesarios del resultado.
- **Compatibilidad con comandos de shell**: Evalúa comandos como `ls`, `find`, etc., además de scripts personalizados.


## Instalación

1. Clonar este repositorio o descarga el archivo `repl-mode.el`:
   ```bash
   git clone https://github.com/caalma/repl-mode.git
   ```

2. Añadir el archivo `repl-mode.el` a la ruta de carga de Emacs. Por ejemplo, añadir lo siguiente al archivo de configuración (`~/.emacs` o `~/.emacs.d/init.el`):
   ```elisp
   (add-to-list 'load-path "/ruta/al/repositorio/repl-mode")
   (require 'repl-mode)
   ```

3. Activar `repl-mode` en un buffer evaluando el comando:
   ```elisp
   (repl-mode-activate "ruta/al/ejecutable")
   ```
   o mediante `M-x` y `repl-mode-activate`.


## Configuración

Para personalizar el comportamiento de `repl-mode` se pueden ajustar las siguientes variables:

- `repl-mode-result`: Prefijo para indicar el resultado de la evaluación (por defecto, `\n-- `).
- `repl-mode-strip-result`: Elimina espacios innecesarios del resultado (`t` por defecto).
- `repl-mode-history-enabled`: Habilita/deshabilita el historial de líneas (`nil` por defecto).
- `repl-mode-quote-input`: Encomilla automáticamente el input (`t` por defecto).
- `repl-mode-use-stdin`: Pasa el input por `stdin` (`t` por defecto).

Ejemplo de configuración personalizada:
```elisp
(setq repl-mode-result "\n=> ")
(setq repl-mode-strip-result t)
(setq repl-mode-history-enabled nil)
(setq repl-mode-quote-input nil)
(setq repl-mode-use-stdin nil)
```


## Uso

### Comandos principales

- **Evaluar línea actual**: Presiona `Alt+Enter` (`M-RET`).
- **Evaluar con historial forzado**: Presiona `Alt+Shift+Enter` (`M-S-RET`).
- **Evaluar texto seleccionado**: Selecciona un bloque de texto y presiona `Alt+Enter`.

### Ejemplo 1: Script Python

1. Activar el modo REPL con un script Python:
   ```elisp
   (repl-mode-activate "./extras/eval-stdin.py")
   ;; personalizar
   (setq repl-mode-quote-input t)
   (setq repl-mode-use-stdin t)
   ```

2. Escribir una expresión Python:
   ```
   2 + 3
   ```

3. Presionar `Alt+Enter`:
   ```
   2 + 3
   -- 5
   ```

### Ejemplo 2: Comando de shell (`ls`)

1. Activar el modo REPL con el comando `ls`:
   ```elisp
   (repl-mode-activate "ls")
   ;; personalizar
   (setq repl-mode-quote-input nil)
   (setq repl-mode-use-stdin nil)
   ```

2. Escribir un argumento para `ls`:
   ```
   -l -h *
   ```

3. Presionar `Alt+Enter`. Comprobar lista de archivos.

### Ejemplo 3: Texto multilínea

1. Activar el modo REPL con el comando `ls`:
   ```elisp
   (repl-mode-activate "echo -e")
   ;; personalizar
   (setq repl-mode-quote-input nil)
   (setq repl-mode-use-stdin nil)
   ```

2. Seleccionar el siguiente texto multilínea:
   ```
   "texto \n \
   multilinea." > archivo.txt
   ```

2. Presionar `Alt+Enter`. Comprobar que `archivo.txt` contenga:
   ```
   texto
   multilinea.
   ```

## Comparación con otros paquetes disponibles en Emacs

### Diferencias entre `repl-mode` y `comint`

- **Propósito**:
  - `repl-mode`: Simula un REPL ligero para evaluar rápidamente líneas o bloques de texto utilizando un ejecutable externo. Ideal para tareas simples como ejecutar comandos de shell o scripts.
  - `comint`: Proporciona una sesión interactiva completa con procesos externos, como shells o intérpretes de lenguajes de programación. Mantén un estado persistente entre comandos.

- **Sesión interactiva**:
  - `repl-mode`: No mantiene una sesión activa. Cada evaluación es independiente y no guarda estado entre comandos.
  - `comint`: Mantiene una conexión activa con el proceso externo, permitiendo interacciones continuas y estados persistentes.

- **Personalización**:
  - `repl-mode`: Ofrece opciones simples y enfocadas, como personalizar el prefijo del resultado, controlar si se duplican las líneas evaluadas o decidir si el input se pasa por `stdin` o como argumentos.
  - `comint`: Altamente personalizable, con soporte para autocompletado, resaltado de errores y manejo avanzado de entradas/salidas.

- **Evaluación de regiones seleccionadas**:
  - `repl-mode`: Permite evaluar una región de texto seleccionada, lo que es útil para trabajar con bloques de código multilínea o comandos complejos sin necesidad de dividirlos en líneas individuales. Por ejemplo, puedes seleccionar un bloque de texto y enviarlo directamente al ejecutable para su evaluación.
  - `comint`: Aunque puede manejar múltiples líneas, requiere que el usuario envíe los comandos manualmente dentro de la sesión interactiva, lo que puede ser menos conveniente para bloques de texto predefinidos.

- **Casos de uso**:
  - `repl-mode`: Perfecto para evaluar rápidamente código o comandos sin necesidad de iniciar una sesión interactiva completa. Es especialmente útil cuando trabajas con scripts, comandos de shell o fragmentos de código específicos.
  - `comint`: Ideal para flujos de trabajo avanzados que requieren interacción continua con un proceso externo, como desarrollo iterativo en intérpretes de Python o shells.


## Contribuciones

Si encontrás algún error o tenés ideas para nuevas características abrí un issue o enviá un pull request.


## Licencia

Este proyecto está bajo la licencia [MIT](LICENSE). Consulta el archivo `LICENSE` para más detalles.
