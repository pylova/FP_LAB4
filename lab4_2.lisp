(defun remove-each-rnth-reducer (n &optional (key nil))
  (let ((counter 0))
    (lambda (elem acc)
      (incf counter)
      (if (or (and key (funcall key elem))  
              (and (not key) (zerop (mod counter n)))) 
          acc
          (cons elem acc)))))

(defun check-remove-each-rnth-reducer (name input n expected &key initial-value from-end key)
  (let ((result (reduce (remove-each-rnth-reducer n key) input 
                        :from-end from-end 
                        :initial-value initial-value)))
    (format t "~:[FAILED~;PASSED~]... ~a~%" 
            (equal result expected)
            name)
    (when (not (equal result expected))
      (format t "Expected: ~a~%Got: ~a~%~%" expected result))))

(defun test-remove-each-rnth-reducer ()
  "Тестує функцію remove-each-rnth-reducer на різних випадках."
  
  ;; Тести за замовчуванням
  (check-remove-each-rnth-reducer "Test 1" '(1 2 3 4) 2 '(2 4) :from-end t :initial-value '())
  (check-remove-each-rnth-reducer "Test 2" '(1 2 3 4 5 6) 3 '(2 3 5 6) :from-end t :initial-value '())
  (check-remove-each-rnth-reducer "Test 3" '(1 2 3 4 5) 1 '() :from-end t :initial-value '())
  
  ;; Тест для порожнього списку
  (check-remove-each-rnth-reducer "Test 4" '() 2 '() :from-end t :initial-value '())

  ;; Тести з використанням ключового параметру
  (check-remove-each-rnth-reducer "Test 5" '(1 2 3 4) 2 '(1 3) :from-end t :initial-value '() :key #'evenp)
  (check-remove-each-rnth-reducer "Test 6" '(1 2 3 4 5 6) 2 '(2 4 6) :from-end t :initial-value '() :key #'oddp)
  
  ;; Додаткові тести
  (check-remove-each-rnth-reducer "Test 7" '(10 20 30 40 50) 2 '(10 30 50) :from-end t :initial-value '())
  (check-remove-each-rnth-reducer "Test 8" '(10 20 30 40 50) 3 '(10 20 40 50) :from-end t :initial-value '())
  (check-remove-each-rnth-reducer "Test 9" '(1 1 1 1 1) 2 '(1 1 1) :from-end t :initial-value '())
  (check-remove-each-rnth-reducer "Test 10" '(5 6 7 8 9) 1 '(6 8) :from-end t :initial-value '() :key #'oddp))

;; Запуск тестів
(test-remove-each-rnth-reducer)
