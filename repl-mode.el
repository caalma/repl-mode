;;; repl-mode.el --- Modo REPL interactivo para Emacs
;;
;; Autor: Tu Nombre <tu.email@example.com>
;; Versión: 1.0
;; Palabras clave: REPL, evaluación, Emacs
;;
;; Descripción:
;; Este paquete proporciona `repl-mode`, un modo interactivo para simular un REPL (Read-Eval-Print Loop)
;; en Emacs. Permite evaluar líneas de código utilizando un ejecutable externo y muestra los resultados
;; debajo de cada línea.
;;
;; Uso:
;; 1. Activa el modo REPL en un buffer con el comando `(repl-mode-activate "ruta/al/ejecutable")`.
;;    Por ejemplo: `(repl-mode-activate "./eval.py")`.
;; 2. Escribe una expresión en el buffer y presiona `Alt+Enter` para evaluarla.
;; 3. La salida del ejecutable se insertará justo debajo de la línea actual, precedida por el prefijo
;;    definido en `repl-mode-result` (por defecto, `\n-- `).
;; 4. El cursor permanece en su posición actual después de evaluar, permitiendo continuar editando o
;;    escribiendo nuevas expresiones.
;;
;; Personalización:
;; - Puedes cambiar el prefijo de la salida modificando la variable `repl-mode-result`. Por ejemplo:
;;   `(setq repl-mode-result "\n=> ")`.
;; - Puedes desactivar la eliminación de espacios innecesarios configurando `repl-mode-strip-result` en `nil`.
;; - Puedes habilitar/deshabilitar el historial de líneas configurando `repl-mode-history-enabled`.
;; - Usa `Alt+Shift+Enter` para forzar el historial de líneas al evaluar.
;; - Si hay texto seleccionado, se evaluará ese texto en lugar de la línea actual.
;; - Configura `repl-mode-quote-input` para controlar si el input debe ser encomillado.
;; - Configura `repl-mode-use-stdin` para controlar si el input se pasa por stdin o como argumentos.
;;

(defvar repl-mode-executable nil
  "Ruta del ejecutable que se utilizará como backend para el REPL.")

(defvar repl-mode-result "\n-- "
  "Prefijo para indicar el resultado de la evaluación para el REPL.")

(defvar repl-mode-strip-result t
  "Controla la eliminación de espacios iniciales y finales del resultado REPL.
Si es `t`, se eliminan los espacios innecesarios. Si es `nil`, se conserva el resultado tal cual.")

(defvar repl-mode-history-enabled nil
  "Controla si se debe duplicar la línea actual antes de evaluarla para crear un historial.
Si es `t`, se duplica la línea. Si es `nil`, no se duplica.")

(defvar repl-mode-quote-input t
  "Controla si el input debe ser encomillado al construir el comando.
Si es `t`, el input se envuelve en comillas simples. Si es `nil`, no se encomilla.")

(defvar repl-mode-use-stdin t
  "Controla si el input se pasa por stdin o como argumentos al ejecutable.
Si es `t`, el input se pasa por stdin usando <<<. Si es `nil`, el input se pasa como argumentos.")

(define-derived-mode repl-mode fundamental-mode "REPL"
  "Modo para simular un REPL interactivo."
  (local-set-key (kbd "M-RET") 'repl-mode-send-input)          ; Evaluar con Alt+Enter
  (local-set-key (kbd "M-S-<return>") 'repl-mode-send-with-history)) ; Evaluar con Alt+Shift+Enter

(defun repl-mode-activate (executable)
  "Activa el modo REPL con el ejecutable especificado."
  (interactive "fEjecutable: ")
  (setq repl-mode-executable executable)
  (repl-mode)
  ;; Muestra un mensaje en el minibuffer con las combinaciones de teclas para evaluar.
  (message "REPL activado. Usa Alt+Enter (M-RET) para evaluar. Usa Alt+Shift+Enter (M-S-RET) para evaluar con historial."))

(defun repl-mode-build-command (input)
  "Construye el comando Bash según las variables de configuración."
  (if repl-mode-use-stdin
      ;; Pasar el input por stdin usando <<<
      (format "%s <<< %s" repl-mode-executable
              (if repl-mode-quote-input
                  (format "'%s'" input)
                input))
    ;; Pasar el input como argumentos
    (format "%s %s" repl-mode-executable
            (if repl-mode-quote-input
                (format "'%s'" input)
              input))))

(defun repl-mode-send-input ()
  "Envía la línea actual o el texto seleccionado al ejecutable y muestra la salida."
  (interactive)
  (if (use-region-p)
      (repl-mode-evaluate-region (region-beginning) (region-end))
    (repl-mode-evaluate-line)))

(defun repl-mode-send-with-history ()
  "Envía la línea actual al ejecutable con historial forzado."
  (interactive)
  (let ((repl-mode-history-enabled t)) ; Forzar historial
    (repl-mode-send-input)))

(defun repl-mode-evaluate-line ()
  "Evalúa la línea actual y opcionalmente duplica la línea si el historial está habilitado."
  (let* ((input (buffer-substring-no-properties
                 (line-beginning-position) (line-end-position)))
         (command (repl-mode-build-command input))
         (output (shell-command-to-string command)))
    ;; Aplica string-trim solo si repl-mode-strip-result es t.
    (when repl-mode-strip-result
      (setq output (string-trim output)))
    ;; Duplica la línea si el historial está habilitado.
    (when repl-mode-history-enabled
      (save-excursion
        (beginning-of-line)
        (insert input "\n")))
    ;; Inserta la salida debajo de la línea actual.
    (save-excursion
      (end-of-line)
      (insert repl-mode-result output))))

(defun repl-mode-evaluate-region (start end)
  "Evalúa el texto seleccionado entre START y END."
  (let* ((input (buffer-substring-no-properties start end))
         (command (repl-mode-build-command input))
         (output (shell-command-to-string command)))
    ;; Aplica string-trim solo si repl-mode-strip-result es t.
    (when repl-mode-strip-result
      (setq output (string-trim output)))
    ;; Inserta la salida después del texto seleccionado.
    (save-excursion
      (goto-char end)
      (insert repl-mode-result output))))

(provide 'repl-mode)
