;;; send-term --- Send buffer messaget to terminal
;;; Commentary:
;;;   use (send-region-to-term)
;;;--------------------

;;;-------------------
;;; Code:
;;;    define variables
;;;-----------------------
(defvar-local *term-buf-name* "*terminal*" "The buffer name which send to.")
(defvar-local *shell-path* "/bin/bash" "The shell path when new a terminal buffer will use.")


;;;----------------
;;; Code:
;;;   functions
;;;----------------
(defun set-shell-path ()
  "Set the shell path when new a termianl buffer will use."
  (interactive)
  (setf *shell-path* (read-string "shell path: ")))

(defun set-terminal-name ()
  "Set the terminal buffer NAME, default is *terminal*."
  (interactive)
  (setf *term-buf-name* (read-string "New name: ")))

(defun send-region-to-term nil
  "Send mark regeion string to *terminal* buffer with \n end."
  (interactive)
  (unless (get-buffer *term-buf-name*)
    (new-term-buffer *term-buf-name* *shell-path*))
  (send-string *term-buf-name* (buffer-substring-no-properties (region-beginning) (region-end)))
  (send-string *term-buf-name* "\n"))

(defun new-term-buffer (&optional buffer-name shell-path)
  "New a buffer with BUFFER-NAME, and use (term SHELL-PATH)."
  (let ((old-buffer (current-buffer)))
    (setf buffer-name (or buffer-name *term-buf-name*)
          shell-path (or shell-path *shell-path*))
    (split-window)
    (let ((buffer (term shell-path)))
      (message "New buffer: %s." (buffer-name buffer))
      (rename-buffer buffer-name)
      (set-buffer old-buffer)
      buffer)))

(defun send-buffer-to-term nil
  "Send whole buffer to term."
  (interactive)
  (unless (get-buffer *term-buf-name*)
    (new-term-buffer *term-buf-name* *shell-path*))
  (send-string *term-buf-name* (buffer-substring-no-properties 1
                                                               (buffer-end 1)))
  (send-string *term-buf-name* "\n"))

(provide 'send-term)
;;; send-term.el ends here
